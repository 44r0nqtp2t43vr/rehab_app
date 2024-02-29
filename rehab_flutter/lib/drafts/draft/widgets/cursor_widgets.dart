// cursor_widgets.dart
import 'dart:async';

import 'package:flutter/material.dart';

class CursorWidgets {
  // StreamController to broadcast color changes. Make sure to import dart:async if not already done.
  final StreamController<List<Color>> stateController = StreamController<List<Color>>.broadcast();

  // Function to generate cursor widgets based on color and position
  List<Widget> generateCursors(List<Color> colors, List<Offset> positions) {
    List<Widget> cursorWidgets = [];
    for (int i = 0; i < positions.length; i++) {
      cursorWidgets.add(_colorPickerCursor(colors[i], positions[i]));
    }
    return cursorWidgets;
  }

  // Private method to create a cursor widget
  Widget _colorPickerCursor(Color selectedColor, Offset cursorPosition) {
    return Positioned(
      left: cursorPosition.dx - 10,
      top: cursorPosition.dy - 10,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedColor,
          border: Border.all(width: 2.0, color: Colors.white),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
      ),
    );
  }

  // Utility function to check if a color is close to white
  bool isColorCloseToWhite(Color color) {
    int threshold = 240; // Define what you consider "close to white"
    return color.red > threshold && color.green > threshold && color.blue > threshold;
  }

  // Method to update colors; it's a placeholder to show where you might update cursor colors.
  void updateCursorColors(List<Color> newColors) {
    // Assuming you have a mechanism to calculate or update `newColors`
    stateController.add(newColors);
  }

  // Ensure you dispose of the StreamController to avoid memory leaks
  void dispose() {
    stateController.close();
  }
}
