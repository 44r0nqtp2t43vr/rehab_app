import 'package:flutter/material.dart';

class TexturesTester extends StatefulWidget {
  final void Function(double) onResponse;

  const TexturesTester({super.key, required this.onResponse});

  @override
  State<TexturesTester> createState() => _TexturesTesterState();
}

class _TexturesTesterState extends State<TexturesTester> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('textures'),
      ],
    );
  }
}
