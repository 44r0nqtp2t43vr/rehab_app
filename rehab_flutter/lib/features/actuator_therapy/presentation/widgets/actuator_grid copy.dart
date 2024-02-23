import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/widgets/actuator_button.dart';

class ActuatorGrid extends StatelessWidget {
  final List<GlobalKey> circleKeys;
  final List<bool> circleStates;
  final List<bool> permanentGreen;
  final void Function(int, bool) updateState;

  ActuatorGrid({
    Key? key,
    required this.circleKeys,
    required this.circleStates,
    required this.permanentGreen,
    required this.updateState,
  }) : super(key: key);

  // This method now correctly calculates the sum based on the circleStates
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(10.0),
      itemCount: 16,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => updateState(index, !permanentGreen[index]),
          child: ActuatorButton(
            index: index,
            circleKeys: circleKeys,
            circleStates: circleStates,
          ),
        );
      },
    );
  }
}
