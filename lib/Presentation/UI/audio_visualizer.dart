import 'package:flutter/material.dart';

class AudioVisualizer extends StatelessWidget {
  final List<double> audioLevels;
  final Color activeColor;

  const AudioVisualizer({
    super.key,
    required this.audioLevels,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 60),
      painter: _WaveformPainter(levels: audioLevels, color: activeColor),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> levels;
  final Color color;

  _WaveformPainter({required this.levels, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    final centerY = size.height / 2;
    final widthStep = size.width / 40;

    for (int i = 0; i < levels.length; i++) {
      final x = i * widthStep;
      final waveHeight = (levels[i] * size.height).clamp(4.0, size.height);
      canvas.drawLine(
        Offset(x, centerY - (waveHeight / 2)),
        Offset(x, centerY + (waveHeight / 2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.levels != levels;
  }
}
