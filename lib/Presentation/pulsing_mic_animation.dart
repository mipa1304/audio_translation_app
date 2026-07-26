import 'package:flutter/material.dart';

class PulsingMicAnimation extends StatefulWidget {
  const PulsingMicAnimation({super.key});

  @override
  State<PulsingMicAnimation> createState() => _PulsingMicAnimationState();
}

class _PulsingMicAnimationState extends State<PulsingMicAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const Icon(Icons.mic, size: 80, color: Colors.white),
    );
  }
}
