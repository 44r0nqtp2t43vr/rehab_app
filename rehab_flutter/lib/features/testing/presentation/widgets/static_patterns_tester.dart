import 'package:flutter/material.dart';

class StaticPatternsTester extends StatefulWidget {
  final void Function(double) onResponse;

  const StaticPatternsTester({super.key, required this.onResponse});

  @override
  State<StaticPatternsTester> createState() => _StaticPatternsTesterState();
}

class _StaticPatternsTesterState extends State<StaticPatternsTester> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('static patterns'),
      ],
    );
  }
}
