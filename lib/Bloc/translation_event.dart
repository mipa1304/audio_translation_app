import 'package:equatable/equatable.dart';

abstract class TranslationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartListeningEvent extends TranslationEvent {
  final String sourceLang;
  final String targetLang;
  StartListeningEvent({required this.sourceLang, required this.targetLang});
}

class StopListeningEvent extends TranslationEvent {
  @override
  List<Object> get props => [];
}

class TranslateFinalTextEvent extends TranslationEvent {
  final String text;
  final String sourceLang;
  final String targetLang;
  final bool isConversation;
  final int? sessionId;
  TranslateFinalTextEvent({
    required this.text,
    required this.sourceLang,
    required this.targetLang,
    this.isConversation = false,
    this.sessionId,
  });
}

class SpeechRecognitionResultEvent extends TranslationEvent {
  final String text;
  final bool isFinal;
  final String sourceLang;
  final String targetLang;
  final bool isConversation;
  final int sessionId;

  SpeechRecognitionResultEvent({
    required this.text,
    required this.isFinal,
    required this.sourceLang,
    required this.targetLang,
    required this.isConversation,
    required this.sessionId,
  });

  @override
  List<Object> get props => [
    text,
    isFinal,
    sourceLang,
    targetLang,
    isConversation,
    sessionId,
  ];
}

class SpeechRecognitionErrorEvent extends TranslationEvent {
  final String message;
  final int? sessionId;

  SpeechRecognitionErrorEvent(this.message, {this.sessionId});

  @override
  List<Object> get props => [message, sessionId ?? -1];
}

class RestartListeningEvent extends TranslationEvent {
  final String sourceLang;
  final String targetLang;
  final bool isConversation;
  final int sessionId;

  RestartListeningEvent({
    required this.sourceLang,
    required this.targetLang,
    required this.isConversation,
    required this.sessionId,
  });

  @override
  List<Object> get props => [
    sourceLang,
    targetLang,
    isConversation,
    sessionId,
  ];
}

class TranslateInterimTextEvent extends TranslationEvent {
  final String text;
  final String sourceLang;
  final String targetLang;
  final int generation;
  final int sessionId;

  TranslateInterimTextEvent({
    required this.text,
    required this.sourceLang,
    required this.targetLang,
    required this.generation,
    required this.sessionId,
  });

  @override
  List<Object> get props => [
    text,
    sourceLang,
    targetLang,
    generation,
    sessionId,
  ];
}

class SpeakTranslatedTextEvent extends TranslationEvent {
  final String text;
  final String languageCode;

  SpeakTranslatedTextEvent(this.text, this.languageCode);
}

class StartConversationEvent extends TranslationEvent {
  final String lang1;
  final String lang2;

  StartConversationEvent({required this.lang1, required this.lang2});
}

class StopConversationEvent extends TranslationEvent {}

class TranslateImageTextEvent extends TranslationEvent {
  final String text;
  final String sourceLang;
  final String targetLang;

  TranslateImageTextEvent({
    required this.text,
    required this.sourceLang,
    required this.targetLang,
  });
}

class SwitchConversationLanguageEvent extends TranslationEvent {
  @override
  List<Object> get props => [];
}
