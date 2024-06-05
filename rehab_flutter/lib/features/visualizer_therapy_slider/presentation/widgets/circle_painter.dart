// ignore_for_file: unused_import

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/audio_data.dart';

class RayPainter extends CustomPainter {
  final double progress;
  final double totalHeight;
  final double totalWidth;
  final Color color;
  final double circleSize;

  RayPainter({
    this.progress = 1,
    this.totalHeight = 80.0,
    this.totalWidth = 80.0,
    this.color = Colors.blue,
    this.circleSize = 25.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, circleSize, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



// class RayPainter extends CustomPainter {
//   final double progress;
//   final double totalHeight;
//   final double totalWidth;
//   final Color color;
//   late double circleHeight;
//   late double circleWidth;
//   final double rayHeight; // Fixed length of the rays beyond the ellipse's edge
//   final double rayWidth;

//   RayPainter({
//     this.progress = 1,
//     this.totalHeight = 80.0,
//     this.totalWidth = 80.0,
//     this.color = Colors.blue,
//     this.circleHeight = 25.0,
//     this.circleWidth = 25.0,
//     this.rayHeight = 0,
//     this.rayWidth = 80,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = rayWidth
//       ..style = PaintingStyle.fill;

//     final center = Offset(size.width / 2, size.height / 2);


//     Rect ellipseRect = Rect.fromCenter(
//         center: center, width: circleWidth, height: circleHeight);
//     canvas.drawOval(ellipseRect, paint);

//     const totalRays = 20;
//     for (int i = 0; i < totalRays; i++) {
//       final angle = (i * 2 * pi / totalRays) - pi / 2;

//       // Calculate start points on the ellipse perimeter
//       final double ellipseRadiusX = circleWidth / 2;
//       final double ellipseRadiusY = circleHeight / 2;
//       final double startX = center.dx + cos(angle) * ellipseRadiusX;
//       final double startY = center.dy + sin(angle) * ellipseRadiusY;
//       final startOffset = Offset(startX, startY);

//       // Adjust the length of rays based on progress for animation
//       double lengthModifier = rayHeight;
//       if (i % 2 == 0) {
//         // For even rays, "grow" with progress
//         lengthModifier += progress * 10; // Example modifier, adjust as needed
//       } else {
//         // For odd rays, "shrink" with progress (or inverse)
//         lengthModifier += (1 - progress) * 10; // Inverse modifier
//       }

//       // Calculate end points for rays to animate them
//       final double endX = startX + cos(angle) * lengthModifier;
//       final double endY = startY + sin(angle) * lengthModifier;
//       final endOffset = Offset(endX, endY);
//       // final paint = Paint()
//       //   ..color = Colors.lightBlue
//       //   ..strokeWidth = rayWidth
//       //   ..style = PaintingStyle.fill;
//       canvas.drawLine(startOffset, endOffset, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // Always repaint for continuous animation
//     return true;
//   }
// }
