import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';

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
      activeColor: const Color(0xff01FF99),
      value: currentDuration,
      min: minDuration,
      max: maxDuration,
      divisions: (maxDuration - minDuration) ~/ 0.3,
      label: secToMinSec(currentDuration),
      onChanged: onDurationChanged,
    );
  }
}
