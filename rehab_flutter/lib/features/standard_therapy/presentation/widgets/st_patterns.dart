import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/actuators_display_container.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class STPatterns extends StatefulWidget {
  final AppUser user;
  final int intensity;
  final int countdownDuration;

  const STPatterns({
    super.key,
    required this.user,
    required this.intensity,
    required this.countdownDuration,
  });

  @override
  State<STPatterns> createState() => _STPatternsState();
}

class _STPatternsState extends State<STPatterns> {
  final Random random = Random();
  // final int patternDelay = 500;
  final int durationPerRhythmicPattern = 10;
  late Timer timer;
  late int countdownDuration;
  late int patternDelay;
  late List<RhythmicPattern> rhythmicPatternsList;
  List<bool> circleStates = List.generate(16, (_) => false);
  Timer? _patternTimer;
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

  void _onAnimationFinish() {
    stopPattern();
    incrementCurrentInd();
    startPattern();
  }

  void sendPattern(String data) {
    sl<BluetoothBloc>().add(WriteDataEvent(data));
  }

  void startPattern() {
    _patternTimer = Timer.periodic(Duration(milliseconds: patternDelay), (timer) {
      final String patternToSend = rhythmicPatternsList[currentInd].pattern[timer.tick % rhythmicPatternsList[currentInd].pattern.length];
      setState(() {
        circleStates = patternToCircleStates(patternToSend);
      });
      sendPattern(patternToSend);

      // Check if the elapsed time exceeds the specified duration
      if (timer.tick * patternDelay >= (durationPerRhythmicPattern * 1000)) {
        _onAnimationFinish();
      }
    });
  }

  void stopPattern() {
    _patternTimer?.cancel();
    setState(() {
      circleStates = List.generate(16, (_) => false);
    });
    sendPattern("<000000000000000000000000000000>");
  }

  void incrementCurrentInd() {
    setState(() {
      if (currentInd + 1 == rhythmicPatternsList.length) {
        rhythmicPatternsList.shuffle(random);
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
          stopPattern();
          BlocProvider.of<UserBloc>(context).add(SubmitStandardEvent(StandardData(userId: widget.user.userId, isStandardOne: true)));
        } else {
          if (countdownDuration % durationPerRhythmicPattern == 0) {
            incrementCurrentInd();
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
    patternDelay = (6 - widget.intensity) * 100;
    rhythmicPatternsList = List.from(TestingDataProvider.rhythmicPatterns);
    rhythmicPatternsList.shuffle(random);
    startCountdown();
    super.initState();
    startPattern();
  }

  @override
  void dispose() {
    timer.cancel();
    _patternTimer?.cancel();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridSize = (screenWidth - 40) / 3;

    return Column(
      children: [
        const SizedBox(height: 32),
        TestLabel(label: countdownDuration == 0 ? "None" : rhythmicPatternsList[currentInd].name),
        const SizedBox(height: 16),
        ActuatorsDisplayContainer(
          height: screenWidth,
          gridSize: gridSize,
          isLeftHand: false,
          circleStates: circleStates,
        ),
        const SizedBox(height: 16),
        Text(
          "Time remaining: ${secToMinSec(countdownDuration.toDouble())}",
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
