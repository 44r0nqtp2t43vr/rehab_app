import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final double height;
  final double width;

  const Tile({
    required Key key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
    );
  }
}
