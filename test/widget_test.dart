import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transcription_app/Data/audio_recorder_service.dart';
import 'package:transcription_app/Data/deepgram_token_provider.dart';
import 'package:transcription_app/Data/text_to_speech.dart';
import 'package:transcription_app/Data/translation_api.dart';
import 'package:transcription_app/Data/websocket_transcription_engine.dart';
import 'package:transcription_app/domain/models/transcript_segment.dart';
import 'package:transcription_app/Presentation/bloc/transcription_bloc.dart';
import 'package:transcription_app/Presentation/UI/transcription_screen.dart';

class _FakeAudioRepository implements AudioStreamRepository {
  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<Stream<Uint8List>> startStream() async => const Stream.empty();

  @override
  Future<void> pauseStream() async {}

  @override
  Future<void> resumeStream() async {}

  @override
  Future<void> stopStream() async {}
}

class _FakeTranscriptionEngine implements TranscriptionEngine {
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

class _FakeTranslationRepository extends TranslationRepository {
  @override
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async => text;

  @override
  Future<void> saveTranslationHistory(
    String original,
    String translated,
    String from,
    String to,
  ) async {}
}

class _FakeTextToSpeechService extends TextToSpeechService {}

class _FakeDeepgramTokenProvider implements DeepgramTokenProvider {
  @override
  Future<String> fetchToken() async => 'test-access-token';
}

void main() {
  testWidgets('live translation app renders its home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => TranscriptionBloc(
            audioRepository: _FakeAudioRepository(),
            transcriptionEngine: _FakeTranscriptionEngine(),
            translationRepository: _FakeTranslationRepository(),
            textToSpeechService: _FakeTextToSpeechService(),
            deepgramTokenProvider: _FakeDeepgramTokenProvider(),
          ),
          child: const TranscriptionScreen(),
        ),
      ),
    );

    expect(find.text('Live Audio Translation'), findsOneWidget);
    expect(find.byTooltip('Camera translate'), findsOneWidget);
  });
}
