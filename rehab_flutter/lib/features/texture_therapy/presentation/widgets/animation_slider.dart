import 'package:flutter/material.dart';

class AnimationSlider extends StatelessWidget {
  final int animationDuration;
  final int minDuration;
  final int maxDuration;
  final ValueChanged<double> onDurationChanged;

  const AnimationSlider({
    Key? key,
    required this.animationDuration,
    this.minDuration = 4,
    this.maxDuration = 30,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: const Color(0xff01FF99),
      value: animationDuration.toDouble(),
      min: minDuration.toDouble(),
      max: maxDuration.toDouble(),
      divisions: (maxDuration - minDuration) ~/ 1,
      label: "$animationDuration seconds",
      onChanged: onDurationChanged,
    );
  }
}
