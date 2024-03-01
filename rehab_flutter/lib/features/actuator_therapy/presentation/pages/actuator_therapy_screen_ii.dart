import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/injection_container.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/widgets/actuator_grid.dart';

class ActuatorTherapy extends StatefulWidget {
  const ActuatorTherapy({super.key});

  @override
  ActuatorTherapyState createState() => ActuatorTherapyState();
}

class ActuatorTherapyState extends State<ActuatorTherapy> {
  final List<bool> _circleStates = List.generate(16, (_) => false);
  final List<bool> _permanentGreen = List.generate(16, (_) => false);

  final List<GlobalKey> _circleKeys = List.generate(16, (index) => GlobalKey());
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
    String data = "<$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString>";

    // Check if the data to be sent is different from the last sent pattern
    if (data != lastSentPattern) {
      sl<BluetoothBloc>().add(WriteDataEvent(data));
      debugPrint("Pattern sent: $data");
      lastSentPattern = data; // Update the last sent pattern
    } else {
      debugPrint("Pattern not sent, identical to last pattern.");
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

  void _resetNonPermanentCircles() {
    for (int i = 0; i < _circleStates.length; i++) {
      if (!_permanentGreen[i]) {
        _circleStates[i] = false;
      }
    }
    _sendUpdatedPattern();
  }

  void _updateCircleStateBasedOnPosition(Offset globalPosition, bool isStart) {
    for (int i = 0; i < _circleKeys.length; i++) {
      final RenderBox? box = _circleKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final size = box.size;

        if (globalPosition.dx >= position.dx && globalPosition.dx <= position.dx + size.width && globalPosition.dy >= position.dy && globalPosition.dy <= position.dy + size.height) {
          setState(() {
            if (isStart || !_permanentGreen[i]) {
              _circleStates[i] = true;
            }
          });
          // Break to ensure only the first touched circle is activated
          break;
        }
      }
    }
    _sendUpdatedPattern();
  }

  // ignore: unused_element
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
        title: const Text('Actuator Therapy'),
      ),
      body: GestureDetector(
        onPanStart: (DragStartDetails details) => _updateCircleStateBasedOnPosition(details.globalPosition, true),
        onPanUpdate: (DragUpdateDetails details) => _updateCircleStateBasedOnPosition(details.globalPosition, false),
        onPanEnd: (DragEndDetails details) => setState(_resetNonPermanentCircles),
        child: Center(
          // Use Center to align the child widget in the middle
          child: ActuatorGrid(
            circleKeys: _circleKeys,
            circleStates: _circleStates,
            permanentGreen: _permanentGreen,
            updateState: (int index, bool value) {
              setState(() {
                _permanentGreen[index] = value;
                _circleStates[index] = value;
              });
              _sendUpdatedPattern();
            },
          ),
        ),
      ),
    );
  }
}
