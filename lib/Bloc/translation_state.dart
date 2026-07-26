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

class ConversationTurn {
  final String originalText;
  final String translatedText;
  final int person; // 1 or 2

  ConversationTurn({
    required this.originalText,
    required this.translatedText,
    required this.person,
  });
}

class TranslationConversationInProgress extends TranslationState {
  final List<ConversationTurn> history;
  final int currentUser; // 1 or 2
  final String partialText;

  TranslationConversationInProgress(
      this.history, this.currentUser, this.partialText);
}