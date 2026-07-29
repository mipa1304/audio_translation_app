import 'package:equatable/equatable.dart';

abstract class TranslationState extends Equatable {
  const TranslationState();

  @override
  List<Object> get props => [];
}

class TranslationInitial extends TranslationState {}

class TranslationRecording extends TranslationState {
  final String partialText;
  const TranslationRecording(this.partialText);

  @override
  List<Object> get props => [partialText];
}

class TranslationLoading extends TranslationState {}

class TranslationSuccess extends TranslationState {
  final String originalText;
  final String translatedText;
  const TranslationSuccess(this.originalText, this.translatedText);

  @override
  List<Object> get props => [originalText, translatedText];
}

class TranslationFailure extends TranslationState {
  final String error;
  const TranslationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ImageTranslationSuccess extends TranslationState {
  final String originalText;
  final String translatedText;

  const ImageTranslationSuccess(this.originalText, this.translatedText);

  @override
  List<Object> get props => [originalText, translatedText];
}

class ConversationTurn extends Equatable {
  final String originalText;
  final String translatedText;
  final int person; // 1 or 2

  const ConversationTurn({
    required this.originalText,
    required this.translatedText,
    required this.person,
  });

  @override
  List<Object> get props => [originalText, translatedText, person];
}

class TranslationConversationInProgress extends TranslationState {
  final List<ConversationTurn> history;
  final int currentUser; // 1 or 2
  final String partialText;

  const TranslationConversationInProgress(
    this.history,
    this.currentUser,
    this.partialText,
  );

  @override
  List<Object> get props => [history, currentUser, partialText];
}
