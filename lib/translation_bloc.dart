import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:transcription_app/translation_api.dart';
import 'package:transcription_app/translation_event.dart';
import 'package:transcription_app/translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final TranslationRepository repository;
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = "";

  TranslationBloc(this.repository) : super(TranslationInitial()) {
    on<StartListeningEvent>((event, emit) async {
      bool available = await _speechToText.initialize();
      if (available) {
        _speechToText.listen(
          onResult: (result) {
            _lastWords = result.recognizedWords;
            emit(TranslationRecording(_lastWords));
          },
        );
        emit(TranslationRecording(_lastWords));
      } else {
        emit(TranslationFailure("Speech recognition unavailable"));
      }
    });

    on<StopListeningAndTranslateEvent>((event, emit) async {
      await _speechToText.stop();
      if (_lastWords.isEmpty) {
        emit(TranslationInitial());
        return;
      }

      emit(TranslationLoading());
      try {
        final translated = await repository.translateText(
          text: _lastWords,
          sourceLang: event.sourceLang,
          targetLang: event.targetLang,
        );

        // Save to Firebase NoSQL Firestore
        await repository.saveTranslationHistory(
          _lastWords,
          translated,
          event.sourceLang,
          event.targetLang,
        );

        emit(TranslationSuccess(_lastWords, translated));
      } catch (e) {
        emit(TranslationFailure(e.toString()));
      }
    });
  }
}
