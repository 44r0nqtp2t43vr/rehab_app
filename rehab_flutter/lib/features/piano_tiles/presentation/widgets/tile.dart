import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final double height;
  final double width;

  const Tile({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff275492), width: 2),
      ),
    );
  }
}
