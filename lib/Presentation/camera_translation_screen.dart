import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:transcription_app/Data/translation_api.dart';
import 'package:transcription_app/domain/models/language_config.dart';

class CameraTranslationScreen extends StatefulWidget {
  final TranslationRepository translationRepository;
  final String initialTargetLanguage;

  const CameraTranslationScreen({
    super.key,
    required this.translationRepository,
    required this.initialTargetLanguage,
  });

  @override
  State<CameraTranslationScreen> createState() =>
      _CameraTranslationScreenState();
}

class _CameraTranslationScreenState extends State<CameraTranslationScreen> {
  final Map<TextRecognitionScript, TextRecognizer> _textRecognizers = {
    TextRecognitionScript.latin: TextRecognizer(
      script: TextRecognitionScript.latin,
    ),
  };
  CameraController? _controller;
  CameraDescription? _camera;
  TextRecognitionScript _recognitionScript = TextRecognitionScript.latin;
  String _sourceLanguage = 'auto';
  String _targetLanguage = 'en-US';
  String _recognizedText = '';
  String _translatedText = '';
  String? _cameraError;
  String? _translationError;
  Timer? _translationTimer;
  Timer? _recognitionTimer;
  DateTime _nextFrameTime = DateTime.fromMillisecondsSinceEpoch(0);
  String _pendingTranslationText = '';
  bool _isProcessingFrame = false;
  bool _isTranslating = false;
  bool _isScanning = false;
  bool _isCompletingRecognition = false;
  static const _ocrSourceLanguageCodes = {
    'en-US',
    'es-ES',
    'zh-CN',
    'hi-IN',
    'fr-FR',
    'de-DE',
    'ja-JP',
    'pt-BR',
  };

  @override
  void initState() {
    super.initState();
    _targetLanguage = widget.initialTargetLanguage == 'auto'
        ? 'en-US'
        : widget.initialTargetLanguage;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confirmAndInitializeCamera();
    });
  }

  Future<void> _confirmAndInitializeCamera() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Translate text with your camera?'),
        content: const Text(
          'Text recognition runs on this device. Recognized text is sent to '
          'Google Translate for translation. Camera images are not uploaded '
          'or saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      await _initializeCamera();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final previousController = _controller;
      if (previousController != null) {
        if (previousController.value.isStreamingImages) {
          await previousController.stopImageStream();
        }
        await previousController.dispose();
        _controller = null;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _setCameraError('No camera is available on this device.');
        return;
      }

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      _camera = camera;
      _controller = controller;
      await controller.initialize();
      if (!mounted) return;
      await controller.startImageStream(_processImage);
      if (mounted) setState(() => _isScanning = true);
    } on CameraException catch (error) {
      _setCameraError(error.description ?? error.code);
    } catch (error) {
      _setCameraError('Could not start the camera: $error');
    }
  }

  void _setCameraError(String message) {
    if (!mounted) return;
    setState(() => _cameraError = message);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final controller = _controller;
    final camera = _camera;
    if (controller == null || camera == null || image.planes.length != 1) {
      return null;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    final rotation = _imageRotation(camera, controller);
    if (rotation == null) return null;

    final plane = image.planes.first;
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

  InputImageRotation? _imageRotation(
    CameraDescription camera,
    CameraController controller,
  ) {
    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    }
    if (!Platform.isAndroid) return null;

    final orientationDegrees = switch (controller.value.deviceOrientation) {
      DeviceOrientation.portraitUp => 0,
      DeviceOrientation.landscapeLeft => 270,
      DeviceOrientation.portraitDown => 180,
      DeviceOrientation.landscapeRight => 90,
    };
    final rotation = camera.lensDirection == CameraLensDirection.front
        ? (camera.sensorOrientation + orientationDegrees) % 360
        : (camera.sensorOrientation - orientationDegrees + 360) % 360;
    return InputImageRotationValue.fromRawValue(rotation);
  }

  Future<void> _processImage(CameraImage image) async {
    if (!_isScanning ||
        _isCompletingRecognition ||
        _isProcessingFrame ||
        DateTime.now().isBefore(_nextFrameTime)) {
      return;
    }
    _isProcessingFrame = true;
    _nextFrameTime = DateTime.now().add(const Duration(milliseconds: 700));

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _setCameraError('The camera image format is not supported.');
        final controller = _controller;
        if (controller?.value.isStreamingImages ?? false) {
          await controller!.stopImageStream();
        }
        return;
      }

      final script = _recognitionScript;
      final recognizer = _textRecognizers.putIfAbsent(
        script,
        () => TextRecognizer(script: script),
      );
      final result = await recognizer.processImage(inputImage);
      if (!mounted || script != _recognitionScript) return;

      final recognizedText = result.text.trim();
      if (recognizedText.isNotEmpty && recognizedText != _recognizedText) {
        setState(() {
          _recognizedText = recognizedText;
          _translatedText = '';
          _translationError = null;
        });
        _scheduleRecognitionCompletion(recognizedText);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _cameraError = 'Text recognition failed: $error');
      }
      final controller = _controller;
      if (controller?.value.isStreamingImages ?? false) {
        await controller!.stopImageStream();
      }
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _scheduleRecognitionCompletion(String text) {
    _recognitionTimer?.cancel();
    _recognitionTimer = Timer(const Duration(milliseconds: 1200), () {
      _recognitionTimer = null;
      _finishRecognition(text);
    });
  }

  Future<void> _finishRecognition(String text) async {
    if (!mounted ||
        !_isScanning ||
        _isCompletingRecognition ||
        text != _recognizedText) {
      return;
    }
    if (_isProcessingFrame) {
      _scheduleRecognitionCompletion(text);
      return;
    }

    _isCompletingRecognition = true;
    setState(() {});
    try {
      final controller = _controller;
      if (controller != null && controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
      if (!mounted) return;
      setState(() => _isScanning = false);
      _queueTranslation(text);
    } on CameraException catch (error) {
      _setCameraError(error.description ?? error.code);
    } catch (error) {
      _setCameraError('Could not stop text recognition: $error');
    } finally {
      _isCompletingRecognition = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _startScanning() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (controller.value.isStreamingImages) {
      setState(() => _isScanning = true);
      return;
    }

    _recognitionTimer?.cancel();
    _translationTimer?.cancel();
    _pendingTranslationText = '';
    setState(() {
      _recognizedText = '';
      _translatedText = '';
      _translationError = null;
      _cameraError = null;
      _isScanning = false;
    });

    try {
      await controller.startImageStream(_processImage);
      if (mounted) setState(() => _isScanning = true);
    } on CameraException catch (error) {
      _setCameraError(error.description ?? error.code);
    } catch (error) {
      _setCameraError('Could not resume text recognition: $error');
    }
  }

  void _queueTranslation(String text) {
    _translationTimer?.cancel();
    _pendingTranslationText = text;
    setState(() {
      _translatedText = '';
      _translationError = null;
    });
    if (text.isEmpty) return;

    _schedulePendingTranslation();
  }

  void _schedulePendingTranslation() {
    _translationTimer?.cancel();
    _translationTimer = Timer(const Duration(milliseconds: 450), () {
      _translationTimer = null;
      _translatePendingText();
    });
  }

  Future<void> _translatePendingText() async {
    if (_isTranslating || _pendingTranslationText.isEmpty || !mounted) return;
    final text = _pendingTranslationText;
    final sourceLanguage = _sourceLanguage;
    final targetLanguage = _targetLanguage;
    _pendingTranslationText = '';
    _isTranslating = true;
    setState(() => _translationError = null);

    try {
      final translation = await widget.translationRepository.translateText(
        text: text,
        sourceLang: sourceLanguage,
        targetLang: targetLanguage,
      );
      if (mounted &&
          text == _recognizedText &&
          sourceLanguage == _sourceLanguage &&
          targetLanguage == _targetLanguage) {
        setState(() => _translatedText = translation);
      }
    } catch (error) {
      if (mounted &&
          text == _recognizedText &&
          sourceLanguage == _sourceLanguage &&
          targetLanguage == _targetLanguage) {
        setState(() => _translationError = 'Translation failed: $error');
      }
    } finally {
      _isTranslating = false;
      if (mounted && _pendingTranslationText.isNotEmpty) {
        _schedulePendingTranslation();
      }
    }
  }

  void _selectSourceLanguage(String languageCode) {
    if (languageCode == _sourceLanguage) return;
    final script = switch (languageCode.split('-').first) {
      'zh' => TextRecognitionScript.chinese,
      'hi' => TextRecognitionScript.devanagiri,
      'ja' => TextRecognitionScript.japanese,
      _ => TextRecognitionScript.latin,
    };
    setState(() {
      _sourceLanguage = languageCode;
      _recognitionScript = script;
      _translatedText = '';
      _translationError = null;
      if (_isScanning) _recognizedText = '';
    });
    if (_isScanning) {
      _recognitionTimer?.cancel();
    } else if (_recognizedText.isNotEmpty) {
      _queueTranslation(_recognizedText);
    }
  }

  void _selectTargetLanguage(String languageCode) {
    if (languageCode == _targetLanguage) return;
    setState(() {
      _targetLanguage = languageCode;
      if (_isScanning) {
        _translatedText = '';
        _translationError = null;
      }
    });
    if (!_isScanning) {
      _queueTranslation(_recognizedText);
    }
  }

  void _selectRecognitionScript(TextRecognitionScript script) {
    if (script == _recognitionScript) return;
    setState(() {
      _recognitionScript = script;
      _recognizedText = '';
      _translatedText = '';
      _translationError = null;
    });
    _recognitionTimer?.cancel();
    if (!_isScanning) _startScanning();
  }

  String _scriptName(TextRecognitionScript script) => switch (script) {
    TextRecognitionScript.latin => 'Latin',
    TextRecognitionScript.chinese => 'Chinese',
    TextRecognitionScript.devanagiri => 'Devanagari',
    TextRecognitionScript.japanese => 'Japanese',
    TextRecognitionScript.korean => 'Korean',
  };

  String _languageName(String code) {
    if (code == 'auto') return 'Auto detect';
    return LanguageConfig.supportedLanguages
        .firstWhere((language) => language.code == code)
        .nativeName;
  }

  Future<void> _switchCamera() async {
    try {
      _recognitionTimer?.cancel();
      _translationTimer?.cancel();
      _pendingTranslationText = '';
      final cameras = await availableCameras();
      if (cameras.length < 2 || _controller == null) return;

      final nextCamera = cameras.firstWhere(
        (camera) => camera.lensDirection != _camera?.lensDirection,
        orElse: () => cameras.first,
      );
      final previousController = _controller!;
      if (previousController.value.isStreamingImages) {
        await previousController.stopImageStream();
      }
      await previousController.dispose();
      if (!mounted) return;

      final controller = CameraController(
        nextCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      setState(() {
        _camera = nextCamera;
        _controller = controller;
        _cameraError = null;
        _isScanning = false;
        _recognizedText = '';
        _translatedText = '';
      });
      await controller.initialize();
      if (!mounted) return;
      await controller.startImageStream(_processImage);
      if (mounted) setState(() => _isScanning = true);
    } on CameraException catch (error) {
      _setCameraError(error.description ?? error.code);
    } catch (error) {
      _setCameraError('Could not switch camera: $error');
    }
  }

  @override
  void dispose() {
    _translationTimer?.cancel();
    _recognitionTimer?.cancel();
    final controller = _controller;
    if (controller != null) {
      unawaited(_disposeCamera(controller));
    }
    for (final recognizer in _textRecognizers.values) {
      unawaited(recognizer.close());
    }
    super.dispose();
  }

  Future<void> _disposeCamera(CameraController controller) async {
    if (controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = LanguageConfig.supportedLanguages.firstWhere(
      (language) => language.code == _targetLanguage,
      orElse: () => LanguageConfig.supportedLanguages[1],
    );
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Camera translate'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<TextRecognitionScript>(
            tooltip: 'Choose text script',
            initialValue: _recognitionScript,
            onSelected: _selectRecognitionScript,
            itemBuilder: (context) => [
              for (final script in TextRecognitionScript.values)
                PopupMenuItem(value: script, child: Text(_scriptName(script))),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(child: Text(_scriptName(_recognitionScript))),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Choose translation language',
            initialValue: _targetLanguage,
            onSelected: _selectTargetLanguage,
            itemBuilder: (context) => [
              for (final language in LanguageConfig.supportedLanguages)
                if (language.code != 'auto')
                  PopupMenuItem(
                    value: language.code,
                    child: Text(
                      '${language.flagEmoji}  ${language.nativeName}',
                    ),
                  ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(target.flagEmoji),
                  const SizedBox(width: 6),
                  Text(target.nativeName),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Switch camera',
            onPressed: _switchCamera,
            icon: const Icon(Icons.cameraswitch_outlined),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_cameraError == null &&
              controller != null &&
              controller.value.isInitialized)
            CameraPreview(controller)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_cameraError == null)
                      const CircularProgressIndicator()
                    else ...[
                      const Icon(
                        Icons.no_photography_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _cameraError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() => _cameraError = null);
                          _initializeCamera();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          if (_cameraError == null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: _translationCard(target.nativeName),
            ),
        ],
      ),
    );
  }

  Widget _translationCard(String targetLanguage) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: _recognizedText.isEmpty
          ? Row(
              children: [
                const Icon(Icons.center_focus_weak, color: Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isScanning
                        ? 'Point your camera at text to translate it'
                        : 'Tap Scan again to recognize more text',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Recognized text',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  if (_isScanning)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Hold steady. Recognition stops when the text is stable.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      tooltip: 'Choose source language',
                      initialValue: _sourceLanguage,
                      onSelected: _selectSourceLanguage,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'auto',
                          child: Text('Auto detect'),
                        ),
                        for (final language
                            in LanguageConfig.supportedLanguages)
                          if (_ocrSourceLanguageCodes.contains(language.code))
                            PopupMenuItem(
                              value: language.code,
                              child: Text(language.nativeName),
                            ),
                      ],
                      child: Chip(
                        avatar: const Icon(Icons.translate, size: 16),
                        label: Text('From: ${_languageName(_sourceLanguage)}'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    _recognizedText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Colors.white30, height: 1),
                  ),
                  Text(
                    'Translation · $targetLanguage',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_translationError != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _translationError!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        TextButton.icon(
                          onPressed: () => _queueTranslation(_recognizedText),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry translation'),
                        ),
                      ],
                    )
                  else if (_isScanning)
                    const Text(
                      'Translation starts after recognition stops.',
                      style: TextStyle(color: Colors.white70),
                    )
                  else if (_translatedText.isNotEmpty)
                    SelectableText(
                      _translatedText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (_isTranslating ||
                      _translationTimer != null ||
                      _pendingTranslationText.isNotEmpty)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Text(
                      'No translation yet. Check the text and try again.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  const SizedBox(height: 8),
                  if (_isScanning)
                    FilledButton.icon(
                      onPressed: _isCompletingRecognition
                          ? null
                          : () => _finishRecognition(_recognizedText),
                      icon: const Icon(Icons.translate),
                      label: Text(
                        _isCompletingRecognition
                            ? 'Stopping recognition...'
                            : 'Translate now',
                      ),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: _startScanning,
                      icon: const Icon(Icons.document_scanner_outlined),
                      label: const Text('Scan again'),
                    ),
                ],
              ),
            ),
    );
  }
}
