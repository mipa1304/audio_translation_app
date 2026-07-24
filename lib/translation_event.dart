abstract class TranslationEvent {}

class StartListeningEvent extends TranslationEvent {}

class StopListeningAndTranslateEvent extends TranslationEvent {
  final String sourceLang;
  final String targetLang;
  StopListeningAndTranslateEvent({required this.sourceLang, required this.targetLang});
}