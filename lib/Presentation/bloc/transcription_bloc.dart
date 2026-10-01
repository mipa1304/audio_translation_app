import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/audio_recorder_service.dart';
import '../../data/text_to_speech.dart';
import '../../data/translation_api.dart';
import '../../data/websocket_transcription_engine.dart';
import '../../domain/models/transcript_segment.dart';
import 'transcription_event.dart';
import 'transcription_state.dart';

class TranscriptionBloc extends Bloc<TranscriptionEvent, TranscriptionState> {
  final AudioStreamRepository _audioRepository;
  final TranscriptionEngine _transcriptionEngine;
  final TranslationRepository _translationRepository;
  final TextToSpeechService _textToSpeechService;
  String? _deepgramApiKey = const String.fromEnvironment('DEEPGRAM_API_KEY');

  StreamSubscription<Uint8List>? _audioSubscription;
  StreamSubscription<TranscriptSegment>? _engineSubscription;
  final Set<String> _processedFinalSegmentKeys = {};
  bool _isSpeaking = false;
  bool _isTranslatingInterim = false;
  Timer? _interimTranslationTimer;
  int _interimTranslationGeneration = 0;
  String _pendingInterimText = '';

  TranscriptionBloc({
    required AudioStreamRepository audioRepository,
    required TranscriptionEngine transcriptionEngine,
    required TranslationRepository translationRepository,
    required TextToSpeechService textToSpeechService,
  }) : _audioRepository = audioRepository,
       _transcriptionEngine = transcriptionEngine,
       _translationRepository = translationRepository,
       _textToSpeechService = textToSpeechService,
       super(TranscriptionState.initial()) {
    on<StartTranscriptionRequested>(_onStart);
    on<AudioChunkCaptured>(_onAudioChunkCaptured);
    on<SegmentReceived>(_onSegmentReceived);
    on<TranslateInterimTextRequested>(_onTranslateInterimTextRequested);
    on<PauseTranscriptionRequested>(_onPause);
    on<ResumeTranscriptionRequested>(_onResume);
    on<StopTranscriptionRequested>(_onStop);
    on<LanguageChanged>(_onLanguageChanged);
    on<TargetLanguageChanged>(_onTargetLanguageChanged);
    on<TargetAudioOnlyChanged>(_onTargetAudioOnlyChanged);
  }

  Future<void> _onStart(
    StartTranscriptionRequested event,
    Emitter<TranscriptionState> emit,
  ) async {
    _processedFinalSegmentKeys.clear();
    emit(
      state.copyWith(
        status: TranscriptionStatus.connecting,
        currentLanguage: event.languageCode,
      ),
    );

    try {
      final hasPermission = await _audioRepository.hasPermission();
      if (!hasPermission) {
        emit(
          state.copyWith(
            status: TranscriptionStatus.error,
            errorMessage: 'Microphone permission was denied.',
          ),
        );
        return;
      }

      await _transcriptionEngine.connect(
        apiKey: event.apiKey,
        languageCode: event.languageCode,
      );
      _deepgramApiKey = event.apiKey;

      _engineSubscription = _transcriptionEngine.segmentStream.listen(
        (segment) => add(SegmentReceived(segment)),
        onError: (err) => emit(
          state.copyWith(
            status: TranscriptionStatus.error,
            errorMessage: 'Engine stream failure: $err',
          ),
        ),
      );

      final audioStream = await _audioRepository.startStream();
      _audioSubscription = audioStream.listen(
        (chunk) => add(AudioChunkCaptured(chunk)),
        onError: (err) => emit(
          state.copyWith(
            status: TranscriptionStatus.error,
            errorMessage: 'Audio pipeline error: $err',
          ),
        ),
      );

      emit(state.copyWith(status: TranscriptionStatus.recording));
    } catch (e) {
      emit(
        state.copyWith(
          status: TranscriptionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onAudioChunkCaptured(
    AudioChunkCaptured event,
    Emitter<TranscriptionState> emit,
  ) {
    if (state.status != TranscriptionStatus.recording) return;

    _transcriptionEngine.sendAudioChunk(event.chunk);

    // RMS Calculation for Visualization
    final samples = event.chunk.buffer.asInt16List();
    if (samples.isEmpty) return;

    double sum = 0;
    for (int sample in samples) {
      sum += sample * sample;
    }
    final rms = sqrt(sum / samples.length);
    final normalized = (rms / 32768.0).clamp(0.0, 1.0);

    final updatedLevels = List<double>.from(state.audioLevels)..add(normalized);
    if (updatedLevels.length > 40) updatedLevels.removeAt(0);

    emit(state.copyWith(audioLevels: updatedLevels));
  }

  String _finalSegmentKey(TranscriptSegment segment) {
    final normalizedText = segment.text.trim().toLowerCase();
    return '${state.currentLanguage}|${state.targetLanguage}|$normalizedText';
  }

  Future<void> _onSegmentReceived(
    SegmentReceived event,
    Emitter<TranscriptionState> emit,
  ) async {
    final segment = event.segment;
    if (segment.isFinal) {
      _interimTranslationGeneration++;
      _interimTranslationTimer?.cancel();
      _interimTranslationTimer = null;
      _pendingInterimText = '';

      final segmentKey = _finalSegmentKey(segment);
      if (_processedFinalSegmentKeys.contains(segmentKey)) {
        return;
      }
      _processedFinalSegmentKeys.add(segmentKey);

      final updatedList = List<TranscriptSegment>.from(state.finalizedSegments)
        ..add(segment);
      emit(
        state.copyWith(
          finalizedSegments: updatedList,
          clearInterim: true,
          interimTranslatedText: '',
        ),
      );

      try {
        final translatedText = await _translationRepository.translateText(
          text: segment.text,
          sourceLang: state.currentLanguage,
          targetLang: state.targetLanguage,
        );
        final translations = List<String>.from(state.translatedTexts)
          ..add(translatedText);
        emit(state.copyWith(translatedTexts: translations));
        await _translationRepository.saveTranslationHistory(
          segment.text,
          translatedText,
          state.currentLanguage,
          state.targetLanguage,
        );
        if (state.targetAudioOnly) {
          await _playTranslatedAudioWithMicrophonePaused(translatedText, emit);
        }
      } catch (error) {
        emit(state.copyWith(errorMessage: 'Translation failed: $error'));
      }
    } else {
      _pendingInterimText = segment.text;
      _interimTranslationGeneration++;
      emit(state.copyWith(interimSegment: segment));
      _scheduleInterimTranslation();
    }
  }

  void _scheduleInterimTranslation() {
    if (_isTranslatingInterim || _interimTranslationTimer != null) return;

    _interimTranslationTimer = Timer(const Duration(milliseconds: 300), () {
      _interimTranslationTimer = null;
      if (isClosed || _pendingInterimText.isEmpty) return;

      add(
        TranslateInterimTextRequested(
          text: _pendingInterimText,
          sourceLang: state.currentLanguage,
          targetLang: state.targetLanguage,
          generation: _interimTranslationGeneration,
        ),
      );
    });
  }

  Future<void> _onTranslateInterimTextRequested(
    TranslateInterimTextRequested event,
    Emitter<TranscriptionState> emit,
  ) async {
    if (event.generation != _interimTranslationGeneration ||
        state.interimSegment?.text != event.text ||
        _isTranslatingInterim) {
      return;
    }

    _isTranslatingInterim = true;
    try {
      final translatedText = await _translationRepository.translateText(
        text: event.text,
        sourceLang: event.sourceLang,
        targetLang: event.targetLang,
      );

      if (event.generation == _interimTranslationGeneration &&
          state.interimSegment?.text == event.text &&
          state.targetLanguage == event.targetLang) {
        emit(state.copyWith(interimTranslatedText: translatedText));
      }
    } catch (_) {
      // A transient interim translation failure should not stop transcription.
    } finally {
      _isTranslatingInterim = false;
      if (_pendingInterimText.isNotEmpty &&
          event.generation != _interimTranslationGeneration) {
        _scheduleInterimTranslation();
      }
    }
  }

  void _onTargetLanguageChanged(
    TargetLanguageChanged event,
    Emitter<TranscriptionState> emit,
  ) {
    if (event.newLanguageCode == state.targetLanguage) return;
    _interimTranslationGeneration++;
    _interimTranslationTimer?.cancel();
    _interimTranslationTimer = null;
    emit(
      state.copyWith(
        targetLanguage: event.newLanguageCode,
        interimTranslatedText: '',
      ),
    );
    if (state.interimSegment != null) _scheduleInterimTranslation();
  }

  void _onTargetAudioOnlyChanged(
    TargetAudioOnlyChanged event,
    Emitter<TranscriptionState> emit,
  ) {
    emit(state.copyWith(targetAudioOnly: event.enabled));
  }

  Future<void> _onPause(
    PauseTranscriptionRequested event,
    Emitter<TranscriptionState> emit,
  ) async {
    if (_isSpeaking || state.status != TranscriptionStatus.recording) return;
    await _audioRepository.pauseStream();
    emit(state.copyWith(status: TranscriptionStatus.paused));
  }

  Future<void> _onResume(
    ResumeTranscriptionRequested event,
    Emitter<TranscriptionState> emit,
  ) async {
    if (_isSpeaking || state.status != TranscriptionStatus.paused) return;
    await _audioRepository.resumeStream();
    emit(state.copyWith(status: TranscriptionStatus.recording));
  }

  Future<void> _playTranslatedAudioWithMicrophonePaused(
    String translatedText,
    Emitter<TranscriptionState> emit,
  ) async {
    final resumeAfterSpeech = state.status == TranscriptionStatus.recording;
    var microphonePaused = false;
    _isSpeaking = true;

    try {
      if (resumeAfterSpeech) {
        await _audioRepository.pauseStream();
        microphonePaused = true;
        emit(state.copyWith(status: TranscriptionStatus.paused));
      }

      await _textToSpeechService.playTranslatedAudio(
        translatedText,
        state.targetLanguage,
      );
    } finally {
      _isSpeaking = false;
      if (microphonePaused && state.status == TranscriptionStatus.paused) {
        await _audioRepository.resumeStream();
        emit(state.copyWith(status: TranscriptionStatus.recording));
      }
    }
  }

  Future<void> _onStop(
    StopTranscriptionRequested event,
    Emitter<TranscriptionState> emit,
  ) async {
    _processedFinalSegmentKeys.clear();
    _interimTranslationGeneration++;
    _interimTranslationTimer?.cancel();
    _interimTranslationTimer = null;
    _pendingInterimText = '';
    await _cancelSubscriptions();
    await _audioRepository.stopStream();
    await _transcriptionEngine.disconnect();
    emit(
      state.copyWith(status: TranscriptionStatus.completed, clearInterim: true),
    );
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<TranscriptionState> emit,
  ) async {
    if (event.newLanguageCode == state.currentLanguage) return;

    _interimTranslationGeneration++;
    _interimTranslationTimer?.cancel();
    _interimTranslationTimer = null;
    emit(
      state.copyWith(
        currentLanguage: event.newLanguageCode,
        interimTranslatedText: '',
      ),
    );
    if (state.interimSegment != null) _scheduleInterimTranslation();

    if (state.status == TranscriptionStatus.recording) {
      // Hot-reconnect stream with new language context
      await _transcriptionEngine.disconnect();
      await _transcriptionEngine.connect(
        apiKey: _deepgramApiKey ?? '',
        languageCode: event.newLanguageCode,
      );
    }
  }

  Future<void> _cancelSubscriptions() async {
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    await _engineSubscription?.cancel();
    _engineSubscription = null;
  }

  @override
  Future<void> close() async {
    _interimTranslationTimer?.cancel();
    await _cancelSubscriptions();
    await _audioRepository.stopStream();
    await _transcriptionEngine.disconnect();
    return super.close();
  }
}
