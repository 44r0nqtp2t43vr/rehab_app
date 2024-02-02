import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TouchPaintingScreen(),
      ),
    );
  }
}

class TouchPaintingScreen extends StatefulWidget {
  @override
  _TouchPaintingScreenState createState() => _TouchPaintingScreenState();
}

class _TouchPaintingScreenState extends State<TouchPaintingScreen> {
  List<Offset> points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          points.add(details.localPosition);
        });
      },
      child: CustomPaint(
        painter: BrushPainter(points),
        size: Size.infinite,
      ),
    );
  }
}

class BrushPainter extends CustomPainter {
  final List<Offset> points;
  final double circleSize = 20.0;
  final int rowCount = 4;
  final int columnCount = 8;

  BrushPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var point in points) {
      for (int row = 0; row < rowCount; row++) {
        for (int column = 0; column < columnCount; column++) {
          final offset = Offset(
            point.dx + (column * circleSize * 2.5),
            point.dy + (row * circleSize * 3.0),
          );
          canvas.drawCircle(offset, circleSize, paint);
          // Calculate the number to display based on row and column
          int number = (1 << (row * columnCount + column)).toInt();
          TextSpan span = new TextSpan(
              style: new TextStyle(color: Colors.black),
              text: number.toString());
          TextPainter tp = new TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr);
          tp.layout();
          tp.paint(canvas, offset.translate(-tp.width / 2, -tp.height / 2));
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
