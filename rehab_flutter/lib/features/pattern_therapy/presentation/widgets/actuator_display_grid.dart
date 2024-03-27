import 'package:flutter/material.dart';

class ActuatorDisplayGrid extends StatelessWidget {
  final double size;
  final List<List<bool>> patternData;
  final int currentFrame;

  const ActuatorDisplayGrid({
    Key? key,
    required this.size,
    required this.patternData,
    required this.currentFrame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          final circleColor = patternData[currentFrame][index] == true ? Colors.green : Colors.white;
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
