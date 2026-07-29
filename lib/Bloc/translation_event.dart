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
  TranslateFinalTextEvent({
    required this.text,
    required this.sourceLang,
    required this.targetLang,
    this.isConversation = false,
  });
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
