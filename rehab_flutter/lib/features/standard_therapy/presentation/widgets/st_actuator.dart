import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/actuator_display_grid.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class STActuator extends StatefulWidget {
  final int intensity;
  final int countdownDuration;

  const STActuator({
    super.key,
    required this.intensity,
    required this.countdownDuration,
  });

  @override
  State<STActuator> createState() => _STActuatorState();
}

class _STActuatorState extends State<STActuator> {
  final Random random = Random();
  late Timer timer;
  late int countdownDuration;
  late int intervalBetweenPatterns;
  late List<StaticPattern> staticPatternsList;
  List<bool> circleStates = List.generate(16, (_) => false);
  int currentInd = 0;

  int sideAndValueToCircleStateIndex(bool isLeft, int value) {
    final List<int> cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
    return isLeft ? cursorValues.indexOf(value) : cursorValues.lastIndexOf(value);
  }

  List<bool> patternToCircleStates(String pattern) {
    final actuatorValues = [128, 64, 32, 16, 8, 4, 2, 1];
    final circleStates = List.generate(16, (_) => false);

    if (pattern.isEmpty) {
      return circleStates;
    }

    String firstHalf = pattern.substring(1, 4);
    String secondHalf = pattern.substring(4, 7);
    int left = int.parse(firstHalf);
    int right = int.parse(secondHalf);

    for (int i = 0; i < actuatorValues.length; i++) {
      if (left - actuatorValues[i] >= 0) {
        left -= actuatorValues[i];
        circleStates[sideAndValueToCircleStateIndex(true, actuatorValues[i])] = true;
      }
      if (right - actuatorValues[i] >= 0) {
        right -= actuatorValues[i];
        circleStates[sideAndValueToCircleStateIndex(false, actuatorValues[i])] = true;
      }
    }

    return circleStates;
  }

  void updateCircleStates(String pattern) {
    setState(() {
      circleStates = patternToCircleStates(pattern);
    });
  }

  void sendPattern() {
    String currentPatternString = staticPatternsList[currentInd].pattern;
    String data = "<$currentPatternString$currentPatternString$currentPatternString$currentPatternString$currentPatternString>";

    sl<BluetoothBloc>().add(WriteDataEvent(data));
    updateCircleStates(data);
    // debugPrint("Pattern sent: $data");
  }

  void incrementCurrentInd() {
    setState(() {
      if (currentInd + 1 == staticPatternsList.length) {
        staticPatternsList.shuffle(random);
        currentInd = 0;
      } else {
        currentInd++;
      }
    });
  }

  void startCountdown() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (countdownDuration < 1) {
          setState(() {
            endCountdown();
          });
        } else {
          if (countdownDuration % intervalBetweenPatterns == 0) {
            incrementCurrentInd();
            sendPattern();
          }
          setState(() {
            countdownDuration -= 1;
          });
        }
      },
    );
  }

  void endCountdown() {
    timer.cancel();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    circleStates = List.generate(16, (_) => false);
  }

  @override
  void initState() {
    countdownDuration = widget.countdownDuration;
    intervalBetweenPatterns = (6 - widget.intensity) * 2;
    staticPatternsList = List.from(TestingDataProvider.staticPatterns);
    staticPatternsList.shuffle(random);
    startCountdown();
    sendPattern();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridSize = screenWidth - 40;

    return Column(
      children: [
        const SizedBox(height: 32),
        Text(
          "Time remaining: ${secToMinSec(countdownDuration.toDouble())}",
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: screenWidth,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ActuatorDisplayGrid(
                  size: gridSize,
                  patternData: circleStates,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TestLabel(label: staticPatternsList[currentInd].name),
      ],
    );
  }
}
