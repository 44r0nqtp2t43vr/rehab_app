import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/visualizer_therapy/presentation/widgets/circle_painter.dart';

class RaysAnimationScreen extends StatefulWidget {
  @override
  _RaysAnimationScreenState createState() => _RaysAnimationScreenState();
}

class _RaysAnimationScreenState extends State<RaysAnimationScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alternating Rays Animation"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController!,
          builder: (_, child) {
            return CustomPaint(
              painter: RayPainter(progress: _animationController!.value),
            );
          },
        ),
      ),
    );
  }
}
