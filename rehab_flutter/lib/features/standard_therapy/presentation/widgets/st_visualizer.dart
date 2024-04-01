import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class STVisualizer extends StatefulWidget {
  final AppUser user;
  final Song song;

  const STVisualizer({
    super.key,
    required this.user,
    required this.song,
  });

  @override
  State<STVisualizer> createState() => _STVisualizerState();
}

class _STVisualizerState extends State<STVisualizer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.song.title),
      ],
    );
  }
}
