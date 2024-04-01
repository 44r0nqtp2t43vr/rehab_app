import 'package:flutter/material.dart';

class ActuatorButton extends StatelessWidget {
  final int index;
  final List<GlobalKey> circleKeys;
  final List<bool> circleStates;

  const ActuatorButton({
    Key? key,
    required this.index,
    required this.circleKeys,
    required this.circleStates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: circleKeys[index], // Use the passed index
      decoration: BoxDecoration(
        color: circleStates[index]
            ? const Color(0xff01FF99)
            : Colors.white, // Use the passed index
        shape: BoxShape.circle,
      ),
    );
  }
}
