import 'package:flutter/material.dart';

class LineAudioVisualizerPainter extends CustomPainter {
  final List<double> frequencies;
  final double totalHeight;
  final double totalWidth;
  final Color color;
  final int barsBetweenMainFrequencies;

  LineAudioVisualizerPainter({
    required this.frequencies,
    required this.totalHeight,
    required this.totalWidth,
    required this.color,
    this.barsBetweenMainFrequencies = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final int totalMainBars = frequencies.length;
    final int totalBars = totalMainBars * (barsBetweenMainFrequencies + 1) - 1;
    final double barWidth = size.width / totalBars;

    for (int i = 0; i < totalBars; i++) {
      final double x = barWidth * i + barWidth / 2;
      final int mainIndex = i ~/ (barsBetweenMainFrequencies + 1);
      final int subIndex = i % (barsBetweenMainFrequencies + 1);

      double barHeight;
      if (subIndex == 0 || subIndex == barsBetweenMainFrequencies) {
        if (mainIndex < totalMainBars) {
          barHeight = frequencies[mainIndex] * totalHeight;
        } else {
          barHeight = 0;
        }
      } else {
        final double previousFreq = frequencies[mainIndex];
        final double nextFreq = mainIndex + 1 < totalMainBars
            ? frequencies[mainIndex + 1]
            : previousFreq;
        final double fraction = subIndex / (barsBetweenMainFrequencies + 1);
        final double interpolatedFreq = previousFreq +
            (nextFreq - previousFreq) *
                (1 - (2 * fraction - 1) * (2 * fraction - 1));
        barHeight = interpolatedFreq * totalHeight;
      }

      final double y = totalHeight - barHeight;
      canvas.drawLine(
        Offset(x, totalHeight),
        Offset(x, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
