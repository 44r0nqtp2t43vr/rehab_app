import 'package:flutter/material.dart';

class ActuatorGrid extends StatelessWidget {
  final List<GlobalKey> circleKeys;
  final List<bool> circleStates;
  final List<bool> permanentGreen;
  final void Function(int, bool) updateState;

  const ActuatorGrid({
    Key? key,
    required this.circleKeys,
    required this.circleStates,
    required this.permanentGreen,
    required this.updateState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff223E64),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (col) {
              int index = row * 4 + col;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () => updateState(index, !permanentGreen[index]),
                  child: Container(
                    key: circleKeys[index],
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: circleStates[index] ? const Color(0xff01FF99) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
