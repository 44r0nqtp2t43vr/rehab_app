import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Actuator extends StatelessWidget {
  final ui.Offset? tapPosition;
  final Color tappedColor;
  final double size;

  const Actuator({
    super.key,
    required this.tapPosition,
    required this.tappedColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double adjustedLeft = (tapPosition?.dx ?? 0) - size;
    final double adjustedTop = (tapPosition?.dy ?? 0) - size;

    return Positioned(
      left: adjustedLeft,
      top: adjustedTop,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tappedColor,
        ),
      ),
    );
  }
}
