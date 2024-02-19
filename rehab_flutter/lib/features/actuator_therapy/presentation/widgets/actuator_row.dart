import 'package:flutter/material.dart';
import 'actuator_buttons.dart'; // Ensure this import points to the correct file path

Widget actuatorRow(
  int leftValue,
  int rightValue, {
  required VoidCallback onLeftButtonDoubleTap,
  required VoidCallback onLeftButtonLongPressStart,
  required VoidCallback onLeftButtonLongPressEnd,
  required VoidCallback onRightButtonDoubleTap,
  required VoidCallback onRightButtonLongPressStart,
  required VoidCallback onRightButtonLongPressEnd,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildButton(
        value: leftValue,
        onDoubleTap: onLeftButtonDoubleTap,
        onLongPressStart: onLeftButtonLongPressStart,
        onLongPressEnd: onLeftButtonLongPressEnd,
      ),
      buildButton(
        value: rightValue,
        onDoubleTap: onRightButtonDoubleTap,
        onLongPressStart: onRightButtonLongPressStart,
        onLongPressEnd: onRightButtonLongPressEnd,
      ),
    ],
  );
}
