import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../domain/models/transcript_segment.dart';

abstract class TranscriptionEvent extends Equatable {
  const TranscriptionEvent();
  @override
  List<Object?> get props => [];
}

class StartTranscriptionRequested extends TranscriptionEvent {
  final String languageCode;
  final String apiKey;
  const StartTranscriptionRequested({
    required this.languageCode,
    required this.apiKey,
  });
  @override
  List<Object?> get props => [languageCode, apiKey];
}

class PauseTranscriptionRequested extends TranscriptionEvent {}

class ResumeTranscriptionRequested extends TranscriptionEvent {}

class StopTranscriptionRequested extends TranscriptionEvent {}

class AudioChunkCaptured extends TranscriptionEvent {
  final Uint8List chunk;
  const AudioChunkCaptured(this.chunk);
  @override
  List<Object?> get props => [chunk];
}

class SegmentReceived extends TranscriptionEvent {
  final TranscriptSegment segment;
  const SegmentReceived(this.segment);
  @override
  List<Object?> get props => [segment];
}

class LanguageChanged extends TranscriptionEvent {
  final String newLanguageCode;
  const LanguageChanged(this.newLanguageCode);
  @override
  List<Object?> get props => [newLanguageCode];
}

class TargetLanguageChanged extends TranscriptionEvent {
  final String newLanguageCode;
  const TargetLanguageChanged(this.newLanguageCode);
  @override
  List<Object?> get props => [newLanguageCode];
}

class TargetAudioOnlyChanged extends TranscriptionEvent {
  final bool enabled;
  const TargetAudioOnlyChanged(this.enabled);
  @override
  List<Object?> get props => [enabled];
}
