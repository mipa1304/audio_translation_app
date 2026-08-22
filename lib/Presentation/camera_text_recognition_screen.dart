import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraTextRecognitionScreen extends StatefulWidget {
  const CameraTextRecognitionScreen({super.key});

  @override
  State<CameraTextRecognitionScreen> createState() =>
      _CameraTextRecognitionScreenState();
}

class _CameraTextRecognitionScreenState
    extends State<CameraTextRecognitionScreen> {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isBusy = false;

  // State variables for overlay
  RecognizedText? _recognizedText;
  Size? _cameraImageSize;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameraPermission = await Permission.camera.request();
    if (!cameraPermission.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Camera permission is required for text recognition.",
            ),
          ),
        );
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      setState(() {
        _cameras = cameras;
      });
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("No cameras found.")));
        }
        return;
      }

      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (mounted) {
        _controller!.startImageStream(_processImage);
        setState(() {});
      }
    } on CameraException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Camera setup failed: ${e.description ?? e.code}"),
          ),
        );
      }
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isBusy) return;
    _isBusy = true;

    final imageRotation = _getRotation();

    final inputImage = _inputImageFromCameraImage(image, imageRotation);
    if (inputImage == null) {
      _isBusy = false;
      return;
    }

    try {
      final result = await _textRecognizer.processImage(inputImage);
      if (mounted) {
        setState(() {
          _recognizedText = result;
          _cameraImageSize = Size(
            image.width.toDouble(),
            image.height.toDouble(),
          );
        });
      }
    } catch (e) {
      debugPrint("OCR Error: $e");
    } finally {
      // Throttle processing to avoid overwhelming the CPU
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _isBusy = false;
      }
    }
  }

  InputImageRotation _getRotation() {
    if (Platform.isIOS) {
      return InputImageRotation.rotation0deg;
    } else if (Platform.isAndroid) {
      final camera = _cameras![0];
      final sensorOrientation = camera.sensorOrientation;
      final deviceOrientation = _controller!.value.deviceOrientation;

      int rotationCompensation = 0;
      switch (deviceOrientation) {
        case DeviceOrientation.portraitUp:
          rotationCompensation = 0;
          break;
        case DeviceOrientation.landscapeLeft:
          rotationCompensation = 270;
          break;
        case DeviceOrientation.portraitDown:
          rotationCompensation = 180;
          break;
        case DeviceOrientation.landscapeRight:
          rotationCompensation = 90;
          break;
      }
      return _rotationIntToImageRotation(
        (sensorOrientation - rotationCompensation + 360) % 360,
      );
    }
    return InputImageRotation.rotation0deg;
  }

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    InputImageRotation rotation,
  ) {
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Live Text Recognition"),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: (_controller == null || !_controller!.value.isInitialized)
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final double maxHeight = constraints.maxHeight;
                double previewWidth =
                    maxHeight * _controller!.value.aspectRatio;
                double previewHeight = maxHeight;

                if (previewWidth > constraints.maxWidth) {
                  previewWidth = constraints.maxWidth;
                  previewHeight = previewWidth / _controller!.value.aspectRatio;
                }

                return Center(
                  child: SizedBox(
                    width: previewWidth,
                    height: previewHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_controller!),
                        if (_recognizedText != null && _cameraImageSize != null)
                          CustomPaint(
                            painter: TextOverlayPainter(
                              recognizedText: _recognizedText!,
                              cameraImageSize: _cameraImageSize!,
                              imageRotation: _getRotation(),
                            ),
                          ),
                        Positioned(
                          top: 16,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.text_fields_outlined,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Text Recognition',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Point the camera at signs, menus, or documents',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Detected text',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _recognizedText?.text.isNotEmpty == true
                                      ? _recognizedText!.text
                                      : 'Point the camera at text to start recognition',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class TextOverlayPainter extends CustomPainter {
  final RecognizedText recognizedText;
  final Size cameraImageSize;
  final InputImageRotation imageRotation;

  TextOverlayPainter({
    required this.recognizedText,
    required this.cameraImageSize,
    required this.imageRotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bool rotated = isRotated();

    // Calculate scaling factors based on the display size vs image size
    // Note: If rotated, the visual width is the image's height and vice versa
    final double scaleX =
        size.width / (rotated ? cameraImageSize.height : cameraImageSize.width);
    final double scaleY =
        size.height /
        (rotated ? cameraImageSize.width : cameraImageSize.height);

    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.7);

    for (final textBlock in recognizedText.blocks) {
      final normalizedText = textBlock.text.trim().replaceAll(
        RegExp(r'\s+'),
        ' ',
      );
      if (normalizedText.isEmpty) continue;

      final Rect boundingBox = _scaleAndTransform(
        textBlock.boundingBox,
        scaleX,
        scaleY,
      );

      if (boundingBox.width <= 0 || boundingBox.height <= 0) {
        continue;
      }

      final Paint borderPaint = Paint()
        ..color = Colors.orangeAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRect(boundingBox.inflate(2), backgroundPaint);
      canvas.drawRect(boundingBox.inflate(2), borderPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: normalizedText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
        ellipsis: '…',
      );

      textPainter.layout(maxWidth: boundingBox.width - 8);

      if (textPainter.width > 0 && textPainter.height > 0) {
        final bubbleRect = Rect.fromLTWH(
          boundingBox.left,
          boundingBox.top - textPainter.height - 8,
          textPainter.width + 12,
          textPainter.height + 8,
        );

        final bubblePaint = Paint()
          ..color = Colors.orangeAccent.withOpacity(0.95);
        canvas.drawRRect(
          RRect.fromRectAndRadius(bubbleRect, const Radius.circular(10)),
          bubblePaint,
        );

        final offset = Offset(bubbleRect.left + 6, bubbleRect.top + 4);

        textPainter.paint(canvas, offset);
      }
    }
  }

  bool isRotated() {
    return imageRotation == InputImageRotation.rotation90deg ||
        imageRotation == InputImageRotation.rotation270deg;
  }

  Rect _scaleAndTransform(Rect rect, double scaleX, double scaleY) {
    switch (imageRotation) {
      case InputImageRotation.rotation90deg:
        return Rect.fromLTRB(
          (cameraImageSize.height - rect.bottom) * scaleX,
          rect.left * scaleY,
          (cameraImageSize.height - rect.top) * scaleX,
          rect.right * scaleY,
        );
      case InputImageRotation.rotation180deg:
        return Rect.fromLTRB(
          (cameraImageSize.width - rect.right) * scaleX,
          (cameraImageSize.height - rect.bottom) * scaleY,
          (cameraImageSize.width - rect.left) * scaleX,
          (cameraImageSize.height - rect.top) * scaleY,
        );
      case InputImageRotation.rotation270deg:
        return Rect.fromLTRB(
          rect.top * scaleX,
          (cameraImageSize.width - rect.right) * scaleY,
          rect.bottom * scaleX,
          (cameraImageSize.width - rect.left) * scaleY,
        );
      default:
        return Rect.fromLTRB(
          rect.left * scaleX,
          rect.top * scaleY,
          rect.right * scaleX,
          rect.bottom * scaleY,
        );
    }
  }

  @override
  bool shouldRepaint(TextOverlayPainter oldDelegate) {
    return oldDelegate.recognizedText != recognizedText;
  }
}
