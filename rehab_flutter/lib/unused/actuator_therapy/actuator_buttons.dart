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

          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
          ),
          child: Text(value.toString()),
        ),
      ),
    ),
  );
}
