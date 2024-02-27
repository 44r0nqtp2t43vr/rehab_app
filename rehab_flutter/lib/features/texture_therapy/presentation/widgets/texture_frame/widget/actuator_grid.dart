import 'package:flutter/material.dart';
import 'single_actuator.dart'; // Make sure this import path matches your project structure

class ActuatorGrid {
  // Calculate the sum of all SingleActuator.value if SingleActuator isActivated (based on color not being green)
  static int sumOfLeftActivatedActuators(List<Color> tappedColors, List<int> values, {isHorizontal = true}) {
    int sum = 0;
    if (isHorizontal) {
      // Process only the left actuators (0-1, 4-5, 8-9, ...)
      for (int i = 0; i < tappedColors.length; i += 4) {
        if (i < tappedColors.length && tappedColors[i] == Colors.green) {
          sum += values[i];
        }
        // Check if the next actuator is within the bounds of the list
        if (i + 1 < tappedColors.length && tappedColors[i + 1] == Colors.green) {
          sum += values[i + 1];
        }
      }
    } else {
      // Process only the left actuators (0-1, 4-5, 8-9, ...)
      for (int i = 0; i < 8; i++) {
        if (i < tappedColors.length && tappedColors[i] == Colors.green) {
          sum += values[i];
        }
      }
    }
    return sum;
  }

  static int sumOfRightActivatedActuators(List<Color> tappedColors, List<int> values, {isHorizontal = true}) {
    int sum = 0;
    if (isHorizontal) {
      // Process only the right actuators (2-3, 6-7, 10-11, ...)
      for (int i = 2; i < tappedColors.length; i += 4) {
        if (i < tappedColors.length && tappedColors[i] == Colors.green) {
          sum += values[i];
        }
        // Check if the next actuator is within the bounds of the list
        if (i + 1 < tappedColors.length && tappedColors[i + 1] == Colors.green) {
          sum += values[i + 1];
        }
      }
    } else {
      // Process only the left actuators (0-1, 4-5, 8-9, ...)
      for (int i = 8; i < 16; i++) {
        if (i < tappedColors.length && tappedColors[i] == Colors.green) {
          sum += values[i];
        }
      }
    }
    return sum;
  }

  static List<Widget> buildActuators(List<Offset> tapPositions, List<Color> tappedColors, List<int> values) {
    List<Widget> actuators = [];
    for (int i = 0; i < tapPositions.length; i++) {
      actuators.add(SingleActuator(
        tapPosition: tapPositions[i],
        tappedColor: tappedColors[i],
        value: values[i],
      ));
    }
    return actuators;
  }
}
