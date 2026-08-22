import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';

abstract class AudioStreamRepository {
  Future<bool> hasPermission();
  Future<Stream<Uint8List>> startStream();
  Future<void> pauseStream();
  Future<void> resumeStream();
  Future<void> stopStream();
}

class AudioRecorderService implements AudioStreamRepository {
  final AudioRecorder _recorder = AudioRecorder();
  StreamController<Uint8List>? _controller;

  @override
  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  @override
  Future<Stream<Uint8List>> startStream() async {
    if (!await hasPermission()) {
      throw Exception('Microphone permission denied.');
    }

    _controller = StreamController<Uint8List>();

    // 16kHz sample rate, 16-bit Mono PCM setup for STT engines
    final recordStream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    recordStream.listen(
      (data) {
        if (_controller != null && !_controller!.isClosed) {
          _controller!.add(data);
        }
      },
      onError: (err) {
        if (_controller != null && !_controller!.isClosed) {
          _controller!.addError(err);
        }
      },
    );

    return _controller!.stream;
  }

  @override
  Future<void> pauseStream() async {
    await _recorder.pause();
  }

  @override
  Future<void> resumeStream() async {
    await _recorder.resume();
  }

  @override
  Future<void> stopStream() async {
    await _recorder.stop();
    await _controller?.close();
    _controller = null;
  }
}
