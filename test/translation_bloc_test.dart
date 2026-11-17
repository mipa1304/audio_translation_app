import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:transcription_app/Bloc/translation_bloc.dart';
import 'package:transcription_app/Bloc/translation_event.dart';
import 'package:transcription_app/Bloc/translation_state.dart';
import 'package:transcription_app/Data/text_to_speech.dart';
import 'package:transcription_app/Data/translation_api.dart';
import 'package:transcription_app/Presentation/bloc/transcription_bloc.dart';
import 'package:transcription_app/Presentation/bloc/transcription_event.dart';
import 'package:transcription_app/Presentation/bloc/transcription_state.dart';
import 'package:transcription_app/Presentation/translation_screen.dart';
import 'package:transcription_app/domain/models/transcript_segment.dart';
import 'package:transcription_app/Data/audio_recorder_service.dart'
    as live_data;
import 'package:transcription_app/Data/deepgram_token_provider.dart'
    as live_data;
import 'package:transcription_app/Data/text_to_speech.dart' as live_data;
import 'package:transcription_app/Data/translation_api.dart' as live_data;
import 'package:transcription_app/Data/websocket_transcription_engine.dart'
    as live_data;

class FakeTranslationRepository extends TranslationRepository {
  @override
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    return 'Hola';
  }
}

class FakeTextToSpeechService extends TextToSpeechService {
  int speakCalls = 0;

  @override
  Future<void> speak(String text, String languageCode) async {
    speakCalls += 1;
  }
}

class CountingTranslationBloc extends TranslationBloc {
  int speakEventsDispatched = 0;

  CountingTranslationBloc(super.repository, super.textToSpeechService);

  void emitConversationState() {
    emit(
      TranslationConversationInProgress(
        [
          const ConversationTurn(
            originalText: 'Hello',
            translatedText: 'Hola',
            person: 1,
          ),
        ],
        1,
        '',
      ),
    );
  }

  @override
  void add(TranslationEvent event) {
    if (event is SpeakTranslatedTextEvent) {
      speakEventsDispatched += 1;
    }
    super.add(event);
  }
}

class FakeAudioStreamRepository implements live_data.AudioStreamRepository {
  int pauseCalls = 0;
  int resumeCalls = 0;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<Stream<Uint8List>> startStream() async => const Stream.empty();

  @override
  Future<void> pauseStream() async {
    pauseCalls += 1;
  }

  @override
  Future<void> resumeStream() async {
    resumeCalls += 1;
  }

  @override
  Future<void> stopStream() async {}
}

class FakeTranscriptionEngine implements live_data.TranscriptionEngine {
  @override
  Future<void> connect({
    required String accessToken,
    required String languageCode,
  }) async {}

  @override
  Future<void> disconnect() async {}

  @override
  void sendAudioChunk(Uint8List chunk) {}

  @override
  Stream<TranscriptSegment> get segmentStream => const Stream.empty();
}

class FakeDeepgramTokenProvider implements live_data.DeepgramTokenProvider {
  @override
  Future<String> fetchToken() async => 'test-access-token';
}

class FakeTranscriptionRepository extends live_data.TranslationRepository {
  int translateCalls = 0;
  String? lastTranslatedText;
  String? lastSourceLanguage;
  String? lastTargetLanguage;

  @override
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    translateCalls += 1;
    lastTranslatedText = text;
    lastSourceLanguage = sourceLang;
    lastTargetLanguage = targetLang;
    return 'Hola';
  }

  @override
  Future<void> saveTranslationHistory(
    String original,
    String translated,
    String from,
    String to,
  ) async {}
}

class TargetAwareTranslationRepository extends FakeTranscriptionRepository {
  @override
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    translateCalls += 1;
    lastTranslatedText = text;
    lastSourceLanguage = sourceLang;
    lastTargetLanguage = targetLang;
    await Future<void>.delayed(
      Duration(milliseconds: text == 'First' ? 50 : 5),
    );
    return '$text-$targetLang';
  }
}

class FakeTextToSpeechForTranscription extends live_data.TextToSpeechService {
  int playCalls = 0;
  String? lastTargetLanguage;
  Completer<void>? playGate;

  @override
  Future<void> playTranslatedAudio(
    String translatedText,
    String targetLanguage,
  ) async {
    playCalls += 1;
    lastTargetLanguage = targetLanguage;
    await playGate?.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'conversation state updates do not auto-trigger duplicate TTS events',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final bloc = CountingTranslationBloc(
        FakeTranslationRepository(),
        FakeTextToSpeechService(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TranslationBloc>.value(
            value: bloc,
            child: const TranslationScreen(),
          ),
        ),
      );

      expect(bloc.speakEventsDispatched, 0);

      bloc.emitConversationState();
      await tester.pump();

      expect(bloc.speakEventsDispatched, 0);
    },
  );

  test(
    'duplicate final transcript segments are only translated once',
    () async {
      final repository = FakeTranscriptionRepository();
      final tts = FakeTextToSpeechForTranscription();
      final bloc = TranscriptionBloc(
        audioRepository: FakeAudioStreamRepository(),
        transcriptionEngine: FakeTranscriptionEngine(),
        translationRepository: repository,
        textToSpeechService: tts,
        deepgramTokenProvider: FakeDeepgramTokenProvider(),
      );

      final segment = TranscriptSegment(
        id: '1',
        text: 'Hello world',
        confidence: 0.99,
        isFinal: true,
        languageCode: 'auto',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
      );

      bloc.add(SegmentReceived(segment));
      bloc.add(SegmentReceived(segment));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.finalizedSegments.length, 1);
      expect(bloc.state.translatedTexts.length, 1);
      expect(repository.translateCalls, 1);
      expect(tts.playCalls, 1);

      await bloc.close();
    },
  );

  test(
    'repeated phrases in distinct final segments are translated and spoken',
    () async {
      final repository = FakeTranscriptionRepository();
      final tts = FakeTextToSpeechForTranscription();
      final bloc = TranscriptionBloc(
        audioRepository: FakeAudioStreamRepository(),
        transcriptionEngine: FakeTranscriptionEngine(),
        translationRepository: repository,
        textToSpeechService: tts,
        deepgramTokenProvider: FakeDeepgramTokenProvider(),
      );
      final timestamp = DateTime.now();

      for (final id in ['repeated-1', 'repeated-2']) {
        bloc.add(
          SegmentReceived(
            TranscriptSegment(
              id: id,
              text: 'Thank you',
              confidence: 0.99,
              isFinal: true,
              languageCode: 'en-US',
              startTime: timestamp,
              endTime: timestamp,
            ),
          ),
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repository.translateCalls, 2);
      expect(bloc.state.finalizedSegments.length, 2);
      expect(bloc.state.translatedTexts.length, 2);
      expect(tts.playCalls, 2);

      await bloc.close();
    },
  );

  test('microphone stays paused until translated speech finishes', () async {
    final audioRepository = FakeAudioStreamRepository();
    final tts = FakeTextToSpeechForTranscription()
      ..playGate = Completer<void>();
    final bloc = TranscriptionBloc(
      audioRepository: audioRepository,
      transcriptionEngine: FakeTranscriptionEngine(),
      translationRepository: FakeTranscriptionRepository(),
      textToSpeechService: tts,
      deepgramTokenProvider: FakeDeepgramTokenProvider(),
    );

    bloc.add(const TargetLanguageChanged('es-ES'));
    bloc.add(const StartTranscriptionRequested(languageCode: 'en-US'));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(bloc.state.status, TranscriptionStatus.recording);

    bloc.add(
      SegmentReceived(
        TranscriptSegment(
          id: 'speech-pause',
          text: 'Hello',
          confidence: 0.99,
          isFinal: true,
          languageCode: 'en-US',
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(tts.playCalls, 1);
    expect(tts.lastTargetLanguage, 'es-ES');
    expect(audioRepository.pauseCalls, 1);
    expect(audioRepository.resumeCalls, 0);
    expect(bloc.state.status, TranscriptionStatus.paused);

    tts.playGate!.complete();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(audioRepository.resumeCalls, 1);
    expect(bloc.state.status, TranscriptionStatus.recording);

    await bloc.close();
  });

  test(
    'interim speech is translated into the selected target language',
    () async {
      final repository = FakeTranscriptionRepository();
      final bloc = TranscriptionBloc(
        audioRepository: FakeAudioStreamRepository(),
        transcriptionEngine: FakeTranscriptionEngine(),
        translationRepository: repository,
        textToSpeechService: FakeTextToSpeechForTranscription(),
        deepgramTokenProvider: FakeDeepgramTokenProvider(),
      );
      bloc.add(const TargetLanguageChanged('es-ES'));

      bloc.add(
        SegmentReceived(
          TranscriptSegment(
            id: 'interim-1',
            text: 'Hello',
            confidence: 0.8,
            isFinal: false,
            languageCode: 'en-US',
            startTime: DateTime.now(),
            endTime: DateTime.now(),
          ),
        ),
      );
      bloc.add(
        SegmentReceived(
          TranscriptSegment(
            id: 'interim-2',
            text: 'Hello there',
            confidence: 0.9,
            isFinal: false,
            languageCode: 'en-US',
            startTime: DateTime.now(),
            endTime: DateTime.now(),
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(repository.translateCalls, 1);
      expect(repository.lastTranslatedText, 'Hello there');
      expect(repository.lastTargetLanguage, 'es-ES');
      expect(bloc.state.interimTranslatedText, 'Hola');

      await bloc.close();
    },
  );

  test(
    'final translations stay with their transcript and follow target changes',
    () async {
      final repository = TargetAwareTranslationRepository();
      final bloc = TranscriptionBloc(
        audioRepository: FakeAudioStreamRepository(),
        transcriptionEngine: FakeTranscriptionEngine(),
        translationRepository: repository,
        textToSpeechService: FakeTextToSpeechForTranscription(),
        deepgramTokenProvider: FakeDeepgramTokenProvider(),
      );
      final timestamp = DateTime.now();

      for (final entry in [('first', 'First'), ('second', 'Second')]) {
        bloc.add(
          SegmentReceived(
            TranscriptSegment(
              id: entry.$1,
              text: entry.$2,
              confidence: 0.99,
              isFinal: true,
              languageCode: 'hi-IN',
              startTime: timestamp,
              endTime: timestamp,
            ),
          ),
        );
      }

      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(bloc.state.translatedTexts, ['First-en-US', 'Second-en-US']);
      expect(repository.lastSourceLanguage, 'hi-IN');

      bloc.add(const TargetLanguageChanged('es-ES'));
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(bloc.state.translatedTexts, ['First-es-ES', 'Second-es-ES']);
      expect(repository.lastTargetLanguage, 'es-ES');
      await bloc.close();
    },
  );
}
