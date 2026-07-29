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
  bool _isListening = false;

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
      await _speechToText.stop();
      emit(TranslationInitial());
    });

    on<TranslateFinalTextEvent>((event, emit) async {
      emit(TranslationLoading());
      try {
        final translated = await repository.translateText(
          text: event.text,
          sourceLang: event.sourceLang,
          targetLang: event.targetLang,
        );

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

          await textToSpeechService.speak(translated, event.targetLang);

          // Switch user and start listening again
          _currentUser = _currentUser == 1 ? 2 : 1;
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

          emit(TranslationSuccess(event.text, translated));
          await textToSpeechService.speak(translated, event.targetLang);
        }
      } catch (e) {
        emit(TranslationFailure(e.toString()));
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
    bool available = await _speechToText.initialize(
      onError: (error) {
        _isListening = false;
        emit(TranslationFailure(error.errorMsg));
      },
    );

    _speechToText.statusListener = (status) {
      if (status == SpeechToText.notListeningStatus && _isListening) {
        // If it stops unexpectedly, restart
        _startListening(
          emit: emit,
          sourceLang: sourceLang,
          targetLang: targetLang,
          isConversation: isConversation,
        );
      }
    };

    if (available) {
      _isListening = true;
      _speechToText.listen(
        onResult: (result) {
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            add(
              TranslateFinalTextEvent(
                text: result.recognizedWords,
                sourceLang: sourceLang,
                targetLang: targetLang,
                isConversation: isConversation,
              ),
            );
          } else if (!result.finalResult) {
            if (isConversation) {
              emit(
                TranslationConversationInProgress(
                  _conversationHistory,
                  _currentUser,
                  result.recognizedWords,
                ),
              );
            } else {
              emit(TranslationRecording(result.recognizedWords));
            }
          }
        },
        localeId: sourceLang,
      );
      if (isConversation) {
        emit(
          TranslationConversationInProgress(
            _conversationHistory,
            _currentUser,
            "Listening...",
          ),
        );
      } else {
        emit(TranslationRecording("Listening..."));
      }
    } else {
      _isListening = false;
      emit(TranslationFailure("Speech recognition unavailable"));
    }
  }
}
