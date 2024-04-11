import 'package:flutter/material.dart';

class PatternGridWidget extends StatelessWidget {
  final List<List<int>> patternData;
  final int currentFrame;

  const PatternGridWidget({
    Key? key,
    required this.patternData,
    required this.currentFrame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.all(5),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 16, // Assuming all frames have 16 elements.
        itemBuilder: (context, index) {
          final circleColor = patternData[currentFrame][index] == 1
              ? const Color(0xff01FF99)
              : Colors.white;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
          );
        },
      ),
    );
  }
}
