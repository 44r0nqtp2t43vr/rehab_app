import 'package:flutter/material.dart';

class PatternDelaySlider extends StatelessWidget {
  final double patternDelay;
  final int minDelay;
  final int maxDelay;
  final ValueChanged<double> onDelayChanged;

  const PatternDelaySlider({
    Key? key,
    required this.patternDelay,
    this.minDelay = 20, // Default minimum delay
    this.maxDelay = 1000, // Default maximum delay
    required this.onDelayChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: patternDelay,
      min: minDelay.toDouble(),
      max: maxDelay.toDouble(),
      divisions: (maxDelay - minDelay) ~/ 20, // Adjust divisions based on range
      label: "$patternDelay ms",
      onChanged: onDelayChanged,
    );
  }
}
