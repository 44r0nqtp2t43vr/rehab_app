import 'package:flutter/material.dart';

class SongSlider extends StatelessWidget {
  final double currentDuration;
  final double minDuration;
  final double maxDuration;
  final ValueChanged<double> onDurationChanged;

  const SongSlider({
    Key? key,
    required this.currentDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: currentDuration,
      min: minDuration,
      max: maxDuration,
      divisions: (maxDuration - minDuration) ~/ 1,
      label: "",
      onChanged: onDurationChanged,
    );
  }
}
