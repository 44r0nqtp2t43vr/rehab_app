import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/injection_container.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/widgets/actuator_grid.dart';

class ActuatorTherapy extends StatefulWidget {
  @override
  _ActuatorTherapyState createState() => _ActuatorTherapyState();
}

class _ActuatorTherapyState extends State<ActuatorTherapy> {
  List<bool> _circleStates = List.generate(16, (_) => false);
  List<bool> _permanentGreen = List.generate(16, (_) => false);
  List<GlobalKey> _circleKeys = List.generate(16, (index) => GlobalKey());
  String lastSentPattern = "";

  // Assuming _cursorValues is accessible like this
  final List<int> _cursorValues = [
    1,
    8,
    1,
    8,
    2,
    16,
    2,
    16,
    4,
    32,
    4,
    32,
    64,
    128,
    64,
    128,
  ];

  void _sendUpdatedPattern() {
    final sums = _calculateSumsOfActuators();
    sendPattern(sums['left']!, sums['right']!);
  }

  void sendPattern(int left, int right) {
    String leftString = left.toString().padLeft(3, '0');
    String rightString = right.toString().padLeft(3, '0');
    String data =
        "<$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString>";

    // Check if the data to be sent is different from the last sent pattern
    if (data != lastSentPattern) {
      sl<BluetoothBloc>().add(WriteDataEvent(data));
      print("Pattern sent: $data");
      lastSentPattern = data; // Update the last sent pattern
    } else {
      print("Pattern not sent, identical to last pattern.");
    }
  }

  // Method to calculate the sums of left and right actuator buttons
  Map<String, int> _calculateSumsOfActuators() {
    int leftSum = 0, rightSum = 0;
    for (int i = 0; i < _circleStates.length; i++) {
      if (_circleStates[i]) {
        // Determine if the current index contributes to the left or right sum
        bool isLeft = (i ~/ 2) % 2 == 0;
        if (isLeft) {
          leftSum += _cursorValues[i];
        } else {
          rightSum += _cursorValues[i];
        }
      }
    }
    return {'left': leftSum, 'right': rightSum};
  }

  void _resetNonPermanentGreenCircles() {
    for (int i = 0; i < _circleStates.length; i++) {
      if (!_permanentGreen[i]) {
        _circleStates[i] = false;
      }
    }
    _sendUpdatedPattern();
  }

  void _resetNonPermanentRedCircles() {
    for (int i = 0; i < _circleStates.length; i++) {
      if (!_permanentGreen[i]) {
        _circleStates[i] = false;
      }
    }
    _sendUpdatedPattern();
  }

  void _updateCircleStateOnTap(int index) {
    setState(() {
      // Toggle the state based on whether it's currently permanent green or not
      if (!_permanentGreen[index]) {
        _permanentGreen[index] =
            true; // Make it permanent green on tap if it was not
      } else {
        // If it was permanent green, toggle its state to red but not permanent
        _circleStates[index] = !_circleStates[index];
      }
    });
    _sendUpdatedPattern();
  }

  void _updateCircleStateOnPan(int index, bool isPanEnd) {
    setState(() {
      if (isPanEnd) {
        // Reset to original state onPanEnd
        if (_permanentGreen[index]) {
          _circleStates[index] =
              true; // Reset to green if it was permanent green
        } else {
          _circleStates[index] =
              false; // Reset to red if it was not permanent green
        }
      } else {
        // Toggle state on pan
        _circleStates[index] = !_permanentGreen[index];
      }
    });
    _sendUpdatedPattern();
  }

  void _updateState(int index, bool value) {
    setState(() {
      _permanentGreen[index] = value;
      _circleStates[index] = value;
    });
    _sendUpdatedPattern();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actuator Therapy'),
      ),
      body: GestureDetector(
        onPanStart: (DragStartDetails details) {
          // Implementation needs to identify the circle based on position and call _updateCircleStateOnPan
        },
        onPanUpdate: (DragUpdateDetails details) {
          // Similar to onPanStart, but for continuous pan updates
        },
        onPanEnd: (DragEndDetails details) {
          // Reset non-permanent circles to their original state
        },
        child: ActuatorGrid(
          circleKeys: _circleKeys,
          circleStates: _circleStates,
          permanentGreen: _permanentGreen,
          updateState: _updateState, // Directly use _updateState here
        ),
      ),
    );
  }
}
