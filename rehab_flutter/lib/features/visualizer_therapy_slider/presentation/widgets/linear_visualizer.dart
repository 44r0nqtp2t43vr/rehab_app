import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/widgets/linear_visualizer_painter.dart';

class LineAudioVisualizer extends StatefulWidget {
  final List<double> initialFrequencies;
  final double totalHeight;
  final Color color;
  final int barsBetweenMainFrequencies;

  const LineAudioVisualizer({
    Key? key,
    required this.initialFrequencies,
    required this.totalHeight,
    required this.color,
    this.barsBetweenMainFrequencies = 6,
  }) : super(key: key);

  @override
  LineAudioVisualizerState createState() {
    return LineAudioVisualizerState();
  }
}

class LineAudioVisualizerState extends State<LineAudioVisualizer>
    with SingleTickerProviderStateMixin {
  late List<double> currentFrequencies;
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    currentFrequencies = widget.initialFrequencies;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _initializeAnimations(widget.initialFrequencies);
  }

  void _initializeAnimations(List<double> frequencies) {
    _animations = frequencies.map((frequency) {
      return Tween<double>(begin: frequency, end: frequency)
          .animate(_controller);
    }).toList();
  }

  void updateFrequencies(List<double> newFrequencies) {
    setState(() {
      for (int i = 0; i < newFrequencies.length; i++) {
        _animations[i] = Tween<double>(
          begin: currentFrequencies[i],
          end: newFrequencies[i],
        ).animate(_controller);
      }
      currentFrequencies = newFrequencies;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(MediaQuery.of(context).size.width, widget.totalHeight),
          painter: LineAudioVisualizerPainter(
            frequencies: _animations.map((anim) => anim.value).toList(),
            totalHeight: widget.totalHeight,
            totalWidth: MediaQuery.of(context).size.width,
            color: widget.color,
            barsBetweenMainFrequencies: widget.barsBetweenMainFrequencies,
          ),
        );
      },
    );
  }
}
