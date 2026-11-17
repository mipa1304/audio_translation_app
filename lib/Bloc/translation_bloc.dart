import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:transcription_app/Data/text_to_speech.dart';
import 'package:transcription_app/Data/translation_api.dart';
import 'package:transcription_app/Bloc/translation_event.dart';
import 'package:transcription_app/Bloc/translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final TranslationRepository repository;
  final TextToSpeechService textToSpeechService;
  final SpeechToText _speechToText = SpeechToText();
  Timer? _interimTranslationTimer;
  bool _isListening = false;
  bool _isTranslatingInterim = false;
  bool _isSpeaking = false;
  bool _isRestartingListening = false;
  int _listeningSession = 0;
  int _interimTranslationGeneration = 0;
  String _pendingInterimText = '';
  String _pendingInterimSourceLang = '';
  String _pendingInterimTargetLang = '';
  int _pendingInterimSessionId = 0;

  // Conversation Mode State
  bool _isConversationMode = false;
  late String _conversationLang1;
  late String _conversationLang2;
  int _currentUser = 1;
  final List<ConversationTurn> _conversationHistory = [];

  TranslationBloc(this.repository, this.textToSpeechService)
    : super(TranslationInitial()) {
    on<StartListeningEvent>((event, emit) async {
      if (_isListening || _isConversationMode) return;
      _listeningSession++;
      _isListening = true;

      await _startListening(
        emit: emit,
        sourceLang: event.sourceLang,
        targetLang: event.targetLang,
        isConversation: false,
      );
    });

    on<StopListeningEvent>((event, emit) async {
      if (!_isListening) return;
      _isListening = false;
      _listeningSession++;
      _interimTranslationGeneration++;
      _interimTranslationTimer?.cancel();
      _interimTranslationTimer = null;
      _pendingInterimText = '';
      _pendingInterimSourceLang = '';
      _pendingInterimTargetLang = '';
      await _speechToText.stop();
      emit(TranslationInitial());
    });

    on<SpeechRecognitionResultEvent>(_onSpeechRecognitionResult);
    on<SpeechRecognitionErrorEvent>((event, emit) {
      if (event.sessionId != null && event.sessionId != _listeningSession) {
        return;
      }
      _isListening = false;
      emit(TranslationFailure(event.message));
    });
    on<RestartListeningEvent>(_onRestartListening);
    on<TranslateInterimTextEvent>(_onTranslateInterimText);

    on<TranslateFinalTextEvent>((event, emit) async {
      if (event.sessionId != null && event.sessionId != _listeningSession) {
        return;
      }
      if (event.isConversation) {
        _isListening = false;
        await _speechToText.stop();
        emit(TranslationLoading());
      }
      try {
        final translated = await repository.translateText(
          text: event.text,
          sourceLang: event.sourceLang,
          targetLang: event.targetLang,
        );
        if (event.sessionId != null && event.sessionId != _listeningSession) {
          return;
        }

        if (event.isConversation) {
          _conversationHistory.add(
            ConversationTurn(
              originalText: event.text,
              translatedText: translated,
              person: _currentUser,
            ),
          );

          emit(
            TranslationConversationInProgress(
              _conversationHistory,
              _currentUser,
              "",
            ),
          );

          _isSpeaking = true;
          await textToSpeechService.speak(translated, event.targetLang);
          _isSpeaking = false;
          if (event.sessionId != null && event.sessionId != _listeningSession) {
            return;
          }

          // Switch user and start listening again
          _currentUser = _currentUser == 1 ? 2 : 1;
          _listeningSession++;
          _isListening = true;
          await _startListening(
            emit: emit,
            sourceLang: _currentUser == 1
                ? _conversationLang1
                : _conversationLang2,
            targetLang: _currentUser == 1
                ? _conversationLang2
                : _conversationLang1,
            isConversation: true,
          );
        } else {
          await repository.saveTranslationHistory(
            event.text,
            translated,
            event.sourceLang,
            event.targetLang,
          );
          if (event.sessionId != null && event.sessionId != _listeningSession) {
            return;
          }

          if (_isListening) {
            emit(TranslationRecording(event.text, translatedText: translated));
            _isSpeaking = true;
            await _speechToText.stop();
            await textToSpeechService.speak(translated, event.targetLang);
            _isSpeaking = false;
            if (_isListening &&
                !isClosed &&
                (event.sessionId == null ||
                    event.sessionId == _listeningSession)) {
              await _startListening(
                emit: emit,
                sourceLang: event.sourceLang,
                targetLang: event.targetLang,
                isConversation: false,
              );
            }
          } else {
            emit(TranslationSuccess(event.text, translated));
            await textToSpeechService.speak(translated, event.targetLang);
          }
        }
      } catch (e) {
        _isSpeaking = false;
        if (event.sessionId != null && event.sessionId != _listeningSession) {
          return;
        }
        if (_isListening && !event.isConversation) {
          emit(
            TranslationRecording(
              event.text,
              translationError: 'Translation failed: $e',
            ),
          );
        } else {
          emit(TranslationFailure(e.toString()));
        }
      }
    });

    on<SpeakTranslatedTextEvent>((event, emit) async {
      try {
        await textToSpeechService.speak(event.text, event.languageCode);
      } catch (e) {
        emit(TranslationFailure("Text-to-speech error: ${e.toString()}"));
      }
    });

    on<StartConversationEvent>((event, emit) async {
      _listeningSession++;
      _isConversationMode = true;
      _conversationLang1 = event.lang1;
      _conversationLang2 = event.lang2;
      _currentUser = 1;
      _conversationHistory.clear();

      emit(TranslationConversationInProgress([], 1, ""));

      await _startListening(
        emit: emit,
        sourceLang: _conversationLang1,
        targetLang: _conversationLang2,
        isConversation: true,
      );
    });

    on<StopConversationEvent>((event, emit) async {
      _isConversationMode = false;
      _listeningSession++;
      _interimTranslationGeneration++;
      _interimTranslationTimer?.cancel();
      _interimTranslationTimer = null;
      _pendingInterimText = '';
      _pendingInterimSourceLang = '';
      _pendingInterimTargetLang = '';
      if (_isListening) {
        await _speechToText.stop();
      }
      _isListening = false;
      emit(TranslationInitial());
    });

    on<TranslateImageTextEvent>((event, emit) async {
      if (event.text.isEmpty) return;
      emit(TranslationLoading());
      try {
        final translated = await repository.translateText(
          text: event.text,
          sourceLang: event.sourceLang,
          targetLang: event.targetLang,
        );
        // For simplicity, we'll just emit a success state.
        // A more advanced implementation would hold a list of all detected text blocks.
        emit(ImageTranslationSuccess(event.text, translated));
      } catch (e) {
        emit(TranslationFailure(e.toString()));
      }
    });
  }

  Future<void> _startListening({
    required Emitter<TranslationState> emit,
    required String sourceLang,
    required String targetLang,
    required bool isConversation,
  }) async {
    final sessionId = _listeningSession;
    late final bool available;
    try {
      available = await _speechToText.initialize(
        onError: (error) {
          add(
            SpeechRecognitionErrorEvent(error.errorMsg, sessionId: sessionId),
          );
        },
      );
    } catch (error) {
      if (sessionId == _listeningSession) {
        _isListening = false;
        emit(TranslationFailure('Speech recognition failed: $error'));
      }
      return;
    }

    if (isClosed || !_isListening || sessionId != _listeningSession) return;

    _speechToText.statusListener = (status) {
      if (status == SpeechToText.notListeningStatus &&
          _isListening &&
          !_isSpeaking &&
          sessionId == _listeningSession) {
        add(
          RestartListeningEvent(
            sourceLang: sourceLang,
            targetLang: targetLang,
            isConversation: isConversation,
            sessionId: sessionId,
          ),
        );
      }
    };

    if (available) {
      _isListening = true;
      try {
        await _speechToText.listen(
          onResult: (result) => add(
            SpeechRecognitionResultEvent(
              text: result.recognizedWords,
              isFinal: result.finalResult,
              sourceLang: sourceLang,
              targetLang: targetLang,
              isConversation: isConversation,
              sessionId: sessionId,
            ),
          ),
          localeId: sourceLang,
        );
      } catch (error) {
        if (sessionId == _listeningSession) {
          _isListening = false;
          emit(TranslationFailure('Could not start listening: $error'));
        }
        return;
      }
      if (isClosed || !_isListening || sessionId != _listeningSession) return;
      if (isConversation && state is! TranslationConversationInProgress) {
        emit(
          TranslationConversationInProgress(
            _conversationHistory,
            _currentUser,
            "Listening...",
          ),
        );
      } else if (!isConversation && state is! TranslationRecording) {
        emit(TranslationRecording("Listening..."));
      }
    } else {
      _isListening = false;
      emit(TranslationFailure("Speech recognition unavailable"));
    }
  }

  void _onSpeechRecognitionResult(
    SpeechRecognitionResultEvent event,
    Emitter<TranslationState> emit,
  ) {
    if (!_isListening ||
        _isSpeaking ||
        event.sessionId != _listeningSession ||
        event.text.trim().isEmpty) {
      return;
    }

    if (event.isConversation) {
      if (event.isFinal) {
        add(
          TranslateFinalTextEvent(
            text: event.text,
            sourceLang: event.sourceLang,
            targetLang: event.targetLang,
            isConversation: true,
            sessionId: event.sessionId,
          ),
        );
      } else {
        emit(
          TranslationConversationInProgress(
            _conversationHistory,
            _currentUser,
            event.text,
          ),
        );
      }
      return;
    }

    if (event.isFinal) {
      _interimTranslationGeneration++;
      _interimTranslationTimer?.cancel();
      _interimTranslationTimer = null;
      _pendingInterimText = '';
      _pendingInterimSourceLang = '';
      _pendingInterimTargetLang = '';
      add(
        TranslateFinalTextEvent(
          text: event.text,
          sourceLang: event.sourceLang,
          targetLang: event.targetLang,
          sessionId: event.sessionId,
        ),
      );
      return;
    }

    _pendingInterimText = event.text;
    _pendingInterimSourceLang = event.sourceLang;
    _pendingInterimTargetLang = event.targetLang;
    _pendingInterimSessionId = event.sessionId;
    _interimTranslationGeneration++;
    emit(TranslationRecording(event.text));
    _scheduleInterimTranslation();
  }

  void _scheduleInterimTranslation() {
    if (_interimTranslationTimer != null ||
        _pendingInterimText.isEmpty ||
        !_isListening) {
      return;
    }

    _interimTranslationTimer = Timer(const Duration(milliseconds: 350), () {
      _interimTranslationTimer = null;
      if (isClosed || !_isListening || _pendingInterimText.isEmpty) return;
      add(
        TranslateInterimTextEvent(
          text: _pendingInterimText,
          sourceLang: _pendingInterimSourceLang,
          targetLang: _pendingInterimTargetLang,
          generation: _interimTranslationGeneration,
          sessionId: _pendingInterimSessionId,
        ),
      );
    });
  }

  Future<void> _onTranslateInterimText(
    TranslateInterimTextEvent event,
    Emitter<TranslationState> emit,
  ) async {
    if (!_isListening ||
        event.sessionId != _listeningSession ||
        event.generation != _interimTranslationGeneration ||
        _isTranslatingInterim) {
      return;
    }

    _isTranslatingInterim = true;
    try {
      final translated = await repository.translateText(
        text: event.text,
        sourceLang: event.sourceLang,
        targetLang: event.targetLang,
      );
      if (_isListening &&
          event.sessionId == _listeningSession &&
          event.generation == _interimTranslationGeneration) {
        emit(TranslationRecording(event.text, translatedText: translated));
        _pendingInterimText = '';
      }
    } catch (error) {
      if (_isListening && event.sessionId == _listeningSession) {
        emit(
          TranslationRecording(
            event.text,
            translationError: 'Live translation failed: $error',
          ),
        );
        _pendingInterimText = '';
      }
    } finally {
      _isTranslatingInterim = false;
      if (_pendingInterimText.isNotEmpty &&
          event.generation != _interimTranslationGeneration) {
        _scheduleInterimTranslation();
      }
    }
  }

  Future<void> _onRestartListening(
    RestartListeningEvent event,
    Emitter<TranslationState> emit,
  ) async {
    if (!_isListening ||
        _isSpeaking ||
        _isRestartingListening ||
        event.sessionId != _listeningSession) {
      return;
    }

    _isRestartingListening = true;
    try {
      await _startListening(
        emit: emit,
        sourceLang: event.sourceLang,
        targetLang: event.targetLang,
        isConversation: event.isConversation,
      );
    } finally {
      _isRestartingListening = false;
    }
  }

  @override
  Future<void> close() async {
    _isListening = false;
    _listeningSession++;
    _interimTranslationTimer?.cancel();
    _interimTranslationTimer = null;
    await _speechToText.stop();
    return super.close();
  }
}
