import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_frame/widget/single_actuator.dart';

class ActuatorGrid {
  // get the sum of all SingleActuator.value if SingleActuator isActivated
  static int getSumOfActivatedActuators(List<SingleActuator> actuators) {
    int sum = 0;
    for (SingleActuator actuator in actuators) {
      if (actuator.isActivated) {
        sum += actuator.value;
      }
    }
    return sum;
  }

  static List<Widget> buildActuators(List<Offset> tapPositions,
      List<Color> tappedColors, List<int> cursorValues) {
    List<Widget> actuators = [];
    for (int i = 0; i < tapPositions.length; i++) {
      actuators.add(SingleActuator(
        tapPosition: tapPositions[i],
        tappedColor: tappedColors[i],
        value: cursorValues[i],
      ));
    }
    return actuators;
  }
}
