import 'package:flutter/material.dart';

Widget buildButton({
  required int value,
  required VoidCallback onDoubleTap,
  required VoidCallback onLongPressStart,
  required VoidCallback onLongPressEnd,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        onLongPressStart: (_) => onLongPressStart(),
        onLongPressEnd: (_) => onLongPressEnd(),
        child: ElevatedButton(
          onPressed: () {}, // This is intentionally left empty
          child: Text(value.toString()),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(24),
          ),
        ),
      ),
    ),
  );
}
