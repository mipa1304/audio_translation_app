import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../domain/models/transcript_segment.dart';

abstract class TranscriptionEngine {
  Future<void> connect({required String apiKey, required String languageCode});
  void sendAudioChunk(Uint8List chunk);
  Stream<TranscriptSegment> get segmentStream;
  Future<void> disconnect();
}

class DeepgramWebSocketEngine implements TranscriptionEngine {
  WebSocketChannel? _channel;
  final StreamController<TranscriptSegment> _segmentController =
      StreamController<TranscriptSegment>.broadcast();

  @override
  Stream<TranscriptSegment> get segmentStream => _segmentController.stream;

  @override
  Future<void> connect({
    required String apiKey,
    required String languageCode,
  }) async {
    final trimmedApiKey = apiKey.trim();
    if (trimmedApiKey.isEmpty) {
      throw ArgumentError(
        'Deepgram API key is not configured. Run with '
        '--dart-define=DEEPGRAM_API_KEY=<key>.',
      );
    }

    final uri = Uri(
      scheme: 'wss',
      host: 'api.deepgram.com',
      path: '/v1/listen',
      queryParameters: {
        'encoding': 'linear16',
        'sample_rate': '16000',
        'channels': '1',
        'punctuate': 'true',
        'interim_results': 'true',
        'smart_format': 'true',
        'model': 'nova-3',
        'language': languageCode == 'auto' ? 'multi' : languageCode,
      },
    );

    // Connect with proper Authorization header as per Deepgram API specification
    final channel = IOWebSocketChannel.connect(
      uri,
      headers: {'Authorization': 'Token $trimmedApiKey'},
    );
    _channel = channel;

    try {
      await channel.ready;
    } catch (error) {
      _channel = null;
      throw Exception('Deepgram WebSocket connection failed: $error');
    }

    channel.stream.listen(
      (message) {
        final rawJson = jsonDecode(message.toString());
        if (rawJson['type'] == 'Error') {
          final description =
              rawJson['description'] ?? 'Unknown Deepgram error';
          _segmentController.addError(Exception('Deepgram: $description'));
          return;
        }

        final isFinal = rawJson['is_final'] as bool? ?? false;
        final channel = rawJson['channel'];
        if (channel == null) return;

        final alternatives = channel['alternatives'] as List?;
        if (alternatives == null || alternatives.isEmpty) return;

        final transcript = alternatives[0]['transcript'] as String? ?? '';
        final confidence =
            (alternatives[0]['confidence'] as num?)?.toDouble() ?? 0.0;
        final detectedLang = rawJson['detected_language'] as String?;

        if (transcript.trim().isNotEmpty) {
          final segment = TranscriptSegment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: transcript,
            confidence: confidence,
            isFinal: isFinal,
            languageCode: detectedLang ?? languageCode,
            startTime: DateTime.now(),
            endTime: DateTime.now(),
          );
          _segmentController.add(segment);
        }
      },
      onError: (error) {
        _segmentController.addError(error);
      },
      onDone: () {
        // Handle stream ending or socket reset
      },
    );
  }

  @override
  void sendAudioChunk(Uint8List chunk) {
    if (_channel != null && chunk.isNotEmpty) {
      _channel!.sink.add(chunk);
    }
  }

  @override
  Future<void> disconnect() async {
    // Deepgram requires a empty json signal to flush final output safely
    _channel?.sink.add(jsonEncode({"type": "CloseStream"}));
    await _channel?.sink.close();
    _channel = null;
  }
}
