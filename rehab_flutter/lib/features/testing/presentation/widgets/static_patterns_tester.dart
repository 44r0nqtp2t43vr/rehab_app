import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/widgets/actuator_grid.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class StaticPatternsTester extends StatefulWidget {
  final void Function(double, String) onResponse;
  final StaticPattern currentStaticPattern;
  final int currentItemNo;
  final int totalItemNo;

  const StaticPatternsTester({
    super.key,
    required this.onResponse,
    required this.currentStaticPattern,
    required this.currentItemNo,
    required this.totalItemNo,
  });

  @override
  State<StaticPatternsTester> createState() => _StaticPatternsTesterState();
}

class _StaticPatternsTesterState extends State<StaticPatternsTester> {
  final List<GlobalKey> _circleKeys = List.generate(16, (index) => GlobalKey());
  final List<bool> _circleStates = List.generate(16, (_) => false);
  final List<bool> _isCircleStateUpdated = List.generate(16, (_) => false);
  Timer? _timer;

  void _sendPattern() {
    String currentPatternString = widget.currentStaticPattern.pattern;
    String data = "<$currentPatternString$currentPatternString$currentPatternString$currentPatternString$currentPatternString>";

    sl<BluetoothBloc>().add(WriteDataEvent(data));
    debugPrint("Pattern sent: $data");
  }

  int _sideAndValueToCircleStateIndex(bool isLeft, int value) {
    final List<int> cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
    return isLeft ? cursorValues.indexOf(value) : cursorValues.lastIndexOf(value);
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
    int correctlyAnsweredCount = 0;

    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == correctAnswers[i]) {
        correctlyAnsweredCount++;
      }
    }

    return (correctlyAnsweredCount / answers.length) * 100;
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
    _timer?.cancel();
    widget.onResponse(_calculateAccuracy(), widget.currentStaticPattern.name);
    setState(() {
      for (int i = 0; i < _circleStates.length; i++) {
        _circleStates[i] = false;
      }
    });
  }

  void _sendPatternRepeatedly() {
    // Cancel the previous timer if it exists
    _timer?.cancel();

    // Schedule a new timer to call _sendPattern every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
      sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
      await Future.delayed(const Duration(milliseconds: 200));
      _sendPattern();
    });
  }

  @override
  void initState() {
    super.initState();
    _sendPattern();
    _sendPatternRepeatedly();
  }

  @override
  void didUpdateWidget(covariant StaticPatternsTester oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStaticPattern != oldWidget.currentStaticPattern) {
      _sendPattern();
      _sendPatternRepeatedly();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        TestLabel(label: "Item ${widget.currentItemNo} of ${widget.totalItemNo}"),
        const SizedBox(height: 16),
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              color: const Color(0xff223E64),
              padding: const EdgeInsets.all(48.0),
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
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _onSubmit(),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xff128BED),
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: darkTextTheme().displaySmall,
                ),
              ),
              // AppButton(
              //   onPressed: () => _onSubmit(),
              //   child: const Text('Submit'),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
