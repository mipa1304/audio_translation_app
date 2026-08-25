import 'package:equatable/equatable.dart';
import '../../domain/models/transcript_segment.dart';

enum TranscriptionStatus {
  initial,
  connecting,
  recording,
  paused,
  error,
  completed,
}

class TranscriptionState extends Equatable {
  final TranscriptionStatus status;
  final List<TranscriptSegment> finalizedSegments;
  final TranscriptSegment? interimSegment;
  final String currentLanguage;
  final String targetLanguage;
  final bool targetAudioOnly;
  final List<String> translatedTexts;
  final String? errorMessage;
  final List<double> audioLevels; // Used for live waveform UI

  const TranscriptionState({
    required this.status,
    required this.finalizedSegments,
    this.interimSegment,
    required this.currentLanguage,
    required this.targetLanguage,
    this.targetAudioOnly = true,
    this.translatedTexts = const [],
    this.errorMessage,
    this.audioLevels = const [],
  });

  factory TranscriptionState.initial() {
    return const TranscriptionState(
      status: TranscriptionStatus.initial,
      finalizedSegments: [],
      currentLanguage: 'auto',
      targetLanguage: 'en-US',
    );
  }

  TranscriptionState copyWith({
    TranscriptionStatus? status,
    List<TranscriptSegment>? finalizedSegments,
    TranscriptSegment? interimSegment,
    bool clearInterim = false,
    String? currentLanguage,
    String? targetLanguage,
    bool? targetAudioOnly,
    List<String>? translatedTexts,
    String? errorMessage,
    List<double>? audioLevels,
  }) {
    return TranscriptionState(
      status: status ?? this.status,
      finalizedSegments: finalizedSegments ?? this.finalizedSegments,
      interimSegment: clearInterim
          ? null
          : (interimSegment ?? this.interimSegment),
      currentLanguage: currentLanguage ?? this.currentLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      targetAudioOnly: targetAudioOnly ?? this.targetAudioOnly,
      translatedTexts: translatedTexts ?? this.translatedTexts,
      errorMessage: errorMessage ?? this.errorMessage,
      audioLevels: audioLevels ?? this.audioLevels,
    );
  }

  @override
  List<Object?> get props => [
    status,
    finalizedSegments,
    interimSegment,
    currentLanguage,
    targetLanguage,
    targetAudioOnly,
    translatedTexts,
    errorMessage,
    audioLevels,
  ];
}
