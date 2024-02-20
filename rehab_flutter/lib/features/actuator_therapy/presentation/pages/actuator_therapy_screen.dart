import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/injection_container.dart';

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
    print("Sum of left actuator buttons: ${sums['left']}");
    print("Sum of right actuator buttons: ${sums['right']}");
    // Assuming sendPattern method exists and is correctly implemented
    sendPattern(sums['left']!, sums['right']!);
  }

  @override
  Widget build(BuildContext context) {
    // Removed the pattern sending logic from here to avoid confusion

    return Scaffold(
      appBar: AppBar(
        title: Text('Actuator Therapy'),
      ),
      body: GestureDetector(
        onPanStart: (DragStartDetails details) =>
            _updateCircleStateBasedOnPosition(details.globalPosition, true),
        onPanUpdate: (DragUpdateDetails details) =>
            _updateCircleStateBasedOnPosition(details.globalPosition, false),
        onPanEnd: (DragEndDetails details) =>
            setState(_resetNonPermanentCircles),
        child: ActuatorGrid(
          circleKeys: _circleKeys,
          circleStates: _circleStates,
          permanentGreen: _permanentGreen,
          updateState: (int index, bool value) {
            setState(() {
              _permanentGreen[index] = value;
              _circleStates[index] = value;
            });
            // Moved pattern sending logic to be called explicitly after state updates
            _sendUpdatedPattern();
          },
        ),
      ),
    );
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

  // Assume other necessary methods like _updateCircleStateBasedOnPosition and _resetNonPermanentCircles are defined elsewhere

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
      final RenderBox? box =
          _circleKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final size = box.size;

        if (globalPosition.dx >= position.dx &&
            globalPosition.dx <= position.dx + size.width &&
            globalPosition.dy >= position.dy &&
            globalPosition.dy <= position.dy + size.height) {
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
}

class ActuatorButton extends StatelessWidget {
  final int index;
  final List<GlobalKey> circleKeys;
  final List<bool> circleStates;
  final bool isGreen;
  final int value;

  const ActuatorButton({
    Key? key,
    required this.index,
    required this.circleKeys,
    required this.circleStates,
    required this.isGreen,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: circleKeys[index], // Use the passed index
      decoration: BoxDecoration(
        color: circleStates[index]
            ? Colors.green
            : Colors.red, // Use the passed index
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class ActuatorGrid extends StatelessWidget {
  final List<GlobalKey> circleKeys;
  final List<bool> circleStates;
  final List<bool> permanentGreen;
  final Function(int, bool) updateState;
  final List<int> cursorValues = [
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
            isGreen: circleStates[index],
            value: cursorValues[index],
          ),
        );
      },
    );
  }
}
