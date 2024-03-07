import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/injection_container.dart';

Map<String, int> sendUpdatedPattern(activeValues, lastSentPattern) {
  var sums = calculateSumsOfActuators(activeValues);
  if (sums != lastSentPattern) {
    // Enough time has passed; send the pattern now
    sendPattern(sums['left']!, sums['right']!);
    lastSentPattern = sums;
  } else {
    debugPrint("Same pattern; Not sending");
  }
  return lastSentPattern;
}

void sendPattern(int left, int right) {
  String leftString = left.toString().padLeft(3, '0');
  String rightString = right.toString().padLeft(3, '0');
  String data =
      "<$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString>";

  // Check if the data to be sent is different from the last sent pattern
  // print(data);
  sl<BluetoothBloc>().add(WriteDataEvent(data));
}

Map<String, int> calculateSumsOfActuators(List<int> actuatorValues) {
  int leftSum = 0;
  int rightSum = 0;
  final List<int> cursorValues = [
    1, 8, // 0-1
    1, 8, // 2-3
    2, 16, // 4-5
    2, 16, // 6-7
    4, 32, // 8-9
    4, 32, // 10-11
    64, 128, // 12-13
    64, 128, // 14-15
  ];

  // Iterate through the actuatorValues to calculate the sums
  for (int i = 0; i < actuatorValues.length; i++) {
    // Check if the actuator is active (1)
    if (actuatorValues[i] == 1) {
      // Determine if the index is for a left or right actuator
      if (i % 4 < 2) {
        // Left actuators (0-1, 4-5, 8-9, ...)
        leftSum += cursorValues[i];
      } else {
        // Right actuators (2-3, 6-7, 10-11, ...)
        rightSum += cursorValues[i];
      }
    }
  }

  return {'left': leftSum, 'right': rightSum};
}
