import 'dart:ui';

class RayPainterState {
  String id;
  double progress; // Ensure this can be updated
  double totalHeight;
  double totalWidth;
  double circleHeight;
  double circleWidth;
  double rayHeight;
  double rayWidth;
  Color color;
  double circleSize;

  RayPainterState({
    required this.id,
    required this.progress,
    required this.totalHeight,
    required this.totalWidth,
    required this.circleHeight,
    required this.circleWidth,
    required this.rayHeight,
    required this.rayWidth,
    required this.color,
    required this.circleSize,
  });

  // Other methods or properties
}
