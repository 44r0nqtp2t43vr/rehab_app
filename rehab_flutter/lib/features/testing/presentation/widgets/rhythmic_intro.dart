import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/actuators_display_container.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class RhythmicPatternsIntro extends StatefulWidget {
  final void Function(TestingState) onProceed;

  const RhythmicPatternsIntro({super.key, required this.onProceed});

  @override
  State<RhythmicPatternsIntro> createState() => _RhythmicPatternsIntroState();
}

class _RhythmicPatternsIntroState extends State<RhythmicPatternsIntro> {
  final int patternDelay = 500;
  final int durationPerRhythmicPattern = 10;
  RhythmicPattern currentRhythmicPattern = TestingDataProvider.rhythmicPatterns[0];
  List<bool> circleStates = List.generate(16, (_) => false);
  int currentRhythmicPatternInd = 0;
  Timer? _patternTimer;

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
    if (currentRhythmicPatternInd == TestingDataProvider.rhythmicPatterns.length - 1) {
      stopPattern();
    } else if (currentRhythmicPatternInd < TestingDataProvider.rhythmicPatterns.length - 1) {
      stopPattern();
      setState(() {
        currentRhythmicPatternInd++;
        currentRhythmicPattern = TestingDataProvider.rhythmicPatterns[currentRhythmicPatternInd];
      });
      startPattern();
    }
  }

  void sendPattern(String data) {
    sl<BluetoothBloc>().add(WriteDataEvent(data));
  }

  void startPattern() {
    _patternTimer = Timer.periodic(Duration(milliseconds: patternDelay), (timer) {
      final String patternToSend = currentRhythmicPattern.pattern[timer.tick % currentRhythmicPattern.pattern.length];
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

  @override
  void initState() {
    super.initState();
    startPattern();
  }

  @override
  void dispose() {
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
        TestLabel(label: currentRhythmicPattern.name.capitalize!),
        const SizedBox(height: 16),
        ActuatorsDisplayContainer(
          height: screenWidth,
          gridSize: gridSize,
          isLeftHand: false,
          circleStates: circleStates,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentRhythmicPatternInd < TestingDataProvider.rhythmicPatterns.length - 1
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ElevatedButton(
                        onPressed: () => _onAnimationFinish(),
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xff275492),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xff01FF99),
                          ),
                          elevation: WidgetStateProperty.all<double>(0),
                          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Next Pattern',
                          style: TextStyle(
                            fontFamily: 'Sailec Medium',
                            fontSize: 15,
                            height: 1.2,
                            color: Color(0XFF275492),
                          ),
                        ),
                      ),
                      // AppButton(
                      //   onPressed: () => _onAnimationFinish(),
                      //   child: const Text('Next Pattern'),
                      // ),
                    )
                  : const SizedBox(),

              ElevatedButton(
                onPressed: () => widget.onProceed(TestingState.rhythmicPatterns),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Colors.white,
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    const Color(0XFF128BED),
                  ),
                  elevation: WidgetStateProperty.all<double>(0),
                  shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                  overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Proceed',
                      style: darkTextTheme().displaySmall,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      CupertinoIcons.arrow_right,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              // AppButton(
              //   onPressed: () => widget.onProceed(TestingState.rhythmicPatterns),
              //   child: const Text('Proceed'),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
