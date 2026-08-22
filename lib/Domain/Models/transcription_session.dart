import 'package:equatable/equatable.dart';
import 'transcript_segment.dart';

class TranscriptionSession extends Equatable {
  final String id;
  final String userId;
  final String primaryLanguage;
  final List<TranscriptSegment> segments;
  final DateTime createdAt;
  final DateTime? endedAt;
  final String? audioStoragePath;

  const TranscriptionSession({
    required this.id,
    required this.userId,
    required this.primaryLanguage,
    required this.segments,
    required this.createdAt,
    this.endedAt,
    this.audioStoragePath,
  });

  TranscriptionSession copyWith({
    String? id,
    String? userId,
    String? primaryLanguage,
    List<TranscriptSegment>? segments,
    DateTime? createdAt,
    DateTime? endedAt,
    String? audioStoragePath,
  }) {
    return TranscriptionSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      primaryLanguage: primaryLanguage ?? this.primaryLanguage,
      segments: segments ?? this.segments,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      audioStoragePath: audioStoragePath ?? this.audioStoragePath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'primaryLanguage': primaryLanguage,
    'segments': segments.map((s) => s.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
    'audioStoragePath': audioStoragePath,
  };

  factory TranscriptionSession.fromJson(Map<String, dynamic> json) {
    return TranscriptionSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      primaryLanguage: json['primaryLanguage'] as String,
      segments: (json['segments'] as List<dynamic>)
          .map((s) => TranscriptSegment.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      audioStoragePath: json['audioStoragePath'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    primaryLanguage,
    segments,
    createdAt,
    endedAt,
    audioStoragePath,
  ];
}
