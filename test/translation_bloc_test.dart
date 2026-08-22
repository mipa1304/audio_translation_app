import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transcription_app/Bloc/translation_bloc.dart';
import 'package:transcription_app/Bloc/translation_event.dart';
import 'package:transcription_app/Bloc/translation_state.dart';
import 'package:transcription_app/Data/text_to_speech.dart';
import 'package:transcription_app/Data/translation_api.dart';

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test('emits image block translation success for camera OCR text', () async {
    final bloc = TranslationBloc(
      FakeTranslationRepository(),
      TextToSpeechService(),
    );

    expectLater(
      bloc.stream,
      emits(
        predicate((dynamic state) {
          return state.originalTexts == ['Hello'] &&
              state.translatedTexts == ['Hola'];
        }),
      ),
    );

    // bloc.add(
    //   TranslateImageBlocks(
    //     texts: ['Hello'],
    //     sourceLang: 'en',
    //     targetLang: 'es',
    //   ),
    // );

    // await bloc.stream.firstWhere(
    //   (state) => state is ImageBlocksTranslationSuccess,
    // );
  });
}
