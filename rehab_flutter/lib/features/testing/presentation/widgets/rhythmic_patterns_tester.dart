import 'package:flutter/material.dart';

class RhythmicPatternsTester extends StatefulWidget {
  final void Function(double) onResponse;

  const RhythmicPatternsTester({super.key, required this.onResponse});

  @override
  State<RhythmicPatternsTester> createState() => _RhythmicPatternsTesterState();
}

class _RhythmicPatternsTesterState extends State<RhythmicPatternsTester> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('rhythmic patterns'),
      ],
    );
  }
}
