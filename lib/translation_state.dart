abstract class TranslationState {}

class TranslationInitial extends TranslationState {}
class TranslationRecording extends TranslationState {
  final String partialText;
  TranslationRecording(this.partialText);
}
class TranslationLoading extends TranslationState {}
class TranslationSuccess extends TranslationState {
  final String originalText;
  final String translatedText;
  TranslationSuccess(this.originalText, this.translatedText);
}
class TranslationFailure extends TranslationState {
  final String error;
  TranslationFailure(this.error);
}