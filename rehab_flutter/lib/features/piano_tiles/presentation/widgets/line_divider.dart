import 'package:flutter/material.dart';

class LineDivider extends StatelessWidget {
  const LineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      width: 2,
      color: const Color(0xff275492),
    );
  }
}
