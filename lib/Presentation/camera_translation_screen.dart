import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:transcription_app/Bloc/translation_bloc.dart';
import 'package:transcription_app/Bloc/translation_event.dart';
import 'package:transcription_app/Bloc/translation_state.dart';

class CameraTranslationScreen extends StatefulWidget {
  final String sourceLang;
  final String targetLang;

  const CameraTranslationScreen({
    super.key,
    required this.sourceLang,
    required this.targetLang,
  });

  @override
  State<CameraTranslationScreen> createState() =>
      _CameraTranslationScreenState();
}

class _CameraTranslationScreenState extends State<CameraTranslationScreen> {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isProcessing = false;
  Timer? _processingTimer;
  String? _recognizedText;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    setState(() {
      _cameras = cameras;
    });
    if (_cameras == null || _cameras!.isEmpty) {
      debugPrint("No cameras found");
      return;
    }
    _controller = CameraController(
      _cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller!.initialize();
    if (!mounted) return;
    _controller!.startImageStream(_processImage);
    setState(() {});
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart's CameraImage to ML Kit's InputImage
    final sensorOrientation = _cameras![0].sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          (_controller!.value.deviceOrientation.index + sensorOrientation) %
          360;

      switch (rotationCompensation) {
        case 0:
          rotation = InputImageRotation.rotation0deg;
          break;
        case 90:
          rotation = InputImageRotation.rotation90deg;
          break;
        case 180:
          rotation = InputImageRotation.rotation180deg;
          break;
        case 270:
          rotation = InputImageRotation.rotation270deg;
          break;
        default:
          rotation = InputImageRotation.rotation0deg;
      }
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  void _processImage(CameraImage image) {
    if (_isProcessing) return;
    _isProcessing = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isProcessing = false;
      return;
    }

    _textRecognizer
        .processImage(inputImage)
        .then((recognizedText) {
          if (recognizedText.text.isNotEmpty && mounted) {
            setState(() {
              _recognizedText = recognizedText.text;
            });
            context.read<TranslationBloc>().add(
              TranslateImageTextEvent(
                text: recognizedText.text,
                sourceLang: widget.sourceLang,
                targetLang: widget.targetLang,
              ),
            );
          } else {
            if (mounted) {
              setState(() {
                _recognizedText = null;
              });
            }
          }
        })
        .whenComplete(() {
          // Use a timer to prevent processing every single frame
          _processingTimer = Timer(const Duration(seconds: 2), () {
            _isProcessing = false;
          });
        });
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    _controller?.stopImageStream();
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visual Translation"),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: CameraPreview(_controller!)),
          if (_recognizedText != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Detected: $_recognizedText",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          BlocBuilder<TranslationBloc, TranslationState>(
            builder: (context, state) {
              if (state is ImageTranslationSuccess) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.translatedText,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (state is TranslationLoading &&
                  _recognizedText != null) {
                return const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
