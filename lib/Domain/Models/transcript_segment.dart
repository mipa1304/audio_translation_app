import 'package:equatable/equatable.dart';

class TranscriptSegment extends Equatable {
  final String id;
  final String text;
  final double confidence;
  final bool isFinal;
  final String? languageCode;
  final DateTime startTime;
  final DateTime endTime;

  const TranscriptSegment({
    required this.id,
    required this.text,
    required this.confidence,
    required this.isFinal,
    this.languageCode,
    required this.startTime,
    required this.endTime,
  });

  TranscriptSegment copyWith({
    String? id,
    String? text,
    double? confidence,
    bool? isFinal,
    String? languageCode,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return TranscriptSegment(
      id: id ?? this.id,
      text: text ?? this.text,
      confidence: confidence ?? this.confidence,
      isFinal: isFinal ?? this.isFinal,
      languageCode: languageCode ?? this.languageCode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'confidence': confidence,
    'isFinal': isFinal,
    'languageCode': languageCode,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
  };

  factory TranscriptSegment.fromJson(Map<String, dynamic> json) {
    return TranscriptSegment(
      id: json['id'] as String,
      text: json['text'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      isFinal: json['isFinal'] as bool,
      languageCode: json['languageCode'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    confidence,
    isFinal,
    languageCode,
    startTime,
    endTime,
  ];
}
