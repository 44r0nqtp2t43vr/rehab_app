import 'dart:math';
import 'package:flutter/material.dart';

class RayPainter extends CustomPainter {
  final double progress;
  final double totalHeight;
  final double totalWidth;
  final double midRange;
  late double circleHeight;
  late double circleWidth;
  final double rayHeight; // Fixed length of the rays beyond the ellipse's edge
  final double rayWidth;

  RayPainter({
    required this.progress,
    this.totalHeight = 100.0,
    this.totalWidth = 100.0,
    this.midRange = 0.0,
    this.circleHeight = 25.0,
    this.circleWidth = 25.0,
    this.rayHeight = 0,
    this.rayWidth = 80,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = chooseColor(midRange)
      ..strokeWidth = rayWidth
      ..style = PaintingStyle.fill;

    final center = Offset(totalWidth / 2, totalHeight / 2);

    // Draw the ellipse
    Rect ellipseRect = Rect.fromCenter(center: center, width: circleWidth, height: circleHeight);
    canvas.drawOval(ellipseRect, paint);

    const totalRays = 20;
    for (int i = 0; i < totalRays; i++) {
      final angle = (i * 2 * pi / totalRays) - pi / 2;

      // Calculate start points on the ellipse perimeter
      final double ellipseRadiusX = circleWidth / 2;
      final double ellipseRadiusY = circleHeight / 2;
      final double startX = center.dx + cos(angle) * ellipseRadiusX;
      final double startY = center.dy + sin(angle) * ellipseRadiusY;
      final startOffset = Offset(startX, startY);

      // Adjust the length of rays based on progress for animation
      double lengthModifier = rayHeight;
      if (i % 2 == 0) {
        // For even rays, "grow" with progress
        lengthModifier += progress * 10; // Example modifier, adjust as needed
      } else {
        // For odd rays, "shrink" with progress (or inverse)
        lengthModifier += (1 - progress) * 10; // Inverse modifier
      }

      // Calculate end points for rays to animate them
      final double endX = startX + cos(angle) * lengthModifier;
      final double endY = startY + sin(angle) * lengthModifier;
      final endOffset = Offset(endX, endY);

      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Color chooseColor(double bassEnergy) {
  Color color;
  if (bassEnergy <= 0.1) {
    color = Colors.blue;
  } else if (bassEnergy <= 0.15) {
    color = Colors.cyan;
  } else if (bassEnergy <= 0.2) {
    color = Colors.green;
  } else if (bassEnergy <= 0.25) {
    color = Colors.lightGreen;
  } else if (bassEnergy <= 0.3) {
    color = Colors.lime;
  } else if (bassEnergy <= 0.35) {
    color = Colors.yellow;
  } else if (bassEnergy <= 0.4) {
    color = Colors.amber;
  } else if (bassEnergy <= 0.45) {
    color = Colors.orange;
  } else if (bassEnergy <= 0.5) {
    color = Colors.deepOrange;
  } else if (bassEnergy <= 0.55) {
    color = Colors.red;
  } else if (bassEnergy <= 0.6) {
    color = Colors.pink;
  } else if (bassEnergy <= 0.65) {
    color = Colors.purple;
  } else if (bassEnergy <= 0.7) {
    color = Colors.deepPurple;
  } else if (bassEnergy <= 0.75) {
    color = Colors.indigo;
  } else if (bassEnergy <= 0.8) {
    color = Colors.blueGrey;
  } else if (bassEnergy <= 0.85) {
    color = Colors.brown;
  } else if (bassEnergy <= 0.9) {
    color = Colors.grey;
  } else {
    color = Colors.black;
  }
  return color;
}
