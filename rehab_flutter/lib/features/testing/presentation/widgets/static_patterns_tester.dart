import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/widgets/actuator_grid.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/injection_container.dart';

class StaticPatternsTester extends StatefulWidget {
  final void Function(double) onResponse;
  final StaticPattern currentStaticPattern;
  final int currentItemInd;

  const StaticPatternsTester({super.key, required this.onResponse, required this.currentStaticPattern, required this.currentItemInd});

  @override
  State<StaticPatternsTester> createState() => _StaticPatternsTesterState();
}

class _StaticPatternsTesterState extends State<StaticPatternsTester> {
  final List<GlobalKey> _circleKeys = List.generate(16, (index) => GlobalKey());
  final List<bool> _circleStates = List.generate(16, (_) => false);
  final List<bool> _isCircleStateUpdated = List.generate(16, (_) => false);
  final List<int> _cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];

  void _sendPattern() {
    String currentPatternString = widget.currentStaticPattern.pattern;
    String data = "<$currentPatternString$currentPatternString$currentPatternString$currentPatternString$currentPatternString>";

    sl<BluetoothBloc>().add(WriteDataEvent(data));
    debugPrint("Pattern sent: $data");
  }

  int _sideAndValueToCircleStateIndex(bool isLeft, int value) {
    return isLeft ? _cursorValues.indexOf(value) : _cursorValues.lastIndexOf(value);
  }

  List<bool> _patternToCircleStates(String pattern) {
    final actuatorValues = [128, 64, 32, 16, 8, 4, 2, 1];
    final circleStates = List.generate(16, (_) => false);

    String firstHalf = pattern.substring(0, pattern.length ~/ 2);
    String secondHalf = pattern.substring(pattern.length ~/ 2);
    int left = int.parse(firstHalf);
    int right = int.parse(secondHalf);

    for (int i = 0; i < actuatorValues.length; i++) {
      if (left - actuatorValues[i] >= 0) {
        left -= actuatorValues[i];
        circleStates[_sideAndValueToCircleStateIndex(true, actuatorValues[i])] = true;
      }
      if (right - actuatorValues[i] >= 0) {
        right -= actuatorValues[i];
        circleStates[_sideAndValueToCircleStateIndex(false, actuatorValues[i])] = true;
      }
    }

    return circleStates;
  }

  double _calculateAccuracy() {
    final List<bool> answers = _circleStates;
    final List<bool> correctAnswers = _patternToCircleStates(widget.currentStaticPattern.pattern);
    int shouldBeTrueCount = 0;
    int correctlyAnsweredCount = 0;

    for (int i = 0; i < answers.length; i++) {
      if (correctAnswers[i] == false) {
        continue;
      }
      shouldBeTrueCount++;
      if (answers[i] == true) {
        correctlyAnsweredCount++;
      }
    }

    return (correctlyAnsweredCount / shouldBeTrueCount) * 100;
  }

  void _updateCircleStateBasedOnPosition(Offset globalPosition) {
    for (int i = 0; i < _circleKeys.length; i++) {
      final RenderBox? box = _circleKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final size = box.size;

        if (globalPosition.dx >= position.dx && globalPosition.dx <= position.dx + size.width && globalPosition.dy >= position.dy && globalPosition.dy <= position.dy + size.height) {
          setState(() {
            if (!_isCircleStateUpdated[i]) {
              _circleStates[i] = !_circleStates[i];
              _isCircleStateUpdated[i] = true;
            }
          });
          // Break to ensure only the first touched circle is activated
          break;
        }
      }
    }
  }

  void _onSubmit() {
    widget.onResponse(_calculateAccuracy());
    setState(() {
      for (int i = 0; i < _circleStates.length; i++) {
        _circleStates[i] = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sendPattern();
  }

  @override
  void didUpdateWidget(covariant StaticPatternsTester oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStaticPattern != oldWidget.currentStaticPattern) {
      _sendPattern();
    }
  }

  @override
  void dispose() {
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Item #${widget.currentItemInd + 1}"),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              // Capture initial state of circles
              _updateCircleStateBasedOnPosition(details.globalPosition);
              setState(() {
                for (int i = 0; i < _isCircleStateUpdated.length; i++) {
                  _isCircleStateUpdated[i] = false;
                }
              });
            },
            onPanUpdate: (DragUpdateDetails details) => _updateCircleStateBasedOnPosition(details.globalPosition),
            onPanEnd: (DragEndDetails details) {
              // Reset the flag when the touch ends
              setState(() {
                for (int i = 0; i < _isCircleStateUpdated.length; i++) {
                  _isCircleStateUpdated[i] = true;
                }
              });
            },
            child: Center(
              // Use Center to align the child widget in the middle
              child: ActuatorGrid(
                circleKeys: _circleKeys,
                circleStates: _circleStates,
                permanentGreen: _circleStates,
                updateState: (int index, bool value) {
                  setState(() {
                    _circleStates[index] = value;
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                onPressed: () => _onSubmit(),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
