import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
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
  int currentRhythmicPatternInd = 0;
  Timer? _patternTimer;

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
      sendPattern(currentRhythmicPattern.pattern[timer.tick % currentRhythmicPattern.pattern.length]);

      // Check if the elapsed time exceeds the specified duration
      if (timer.tick * patternDelay >= (durationPerRhythmicPattern * 1000)) {
        _onAnimationFinish();
      }
    });
  }

  void stopPattern() {
    _patternTimer?.cancel();
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
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(child: Text(currentRhythmicPattern.name)),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentRhythmicPatternInd < TestingDataProvider.rhythmicPatterns.length - 1
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: AppButton(
                        onPressed: () => _onAnimationFinish(),
                        child: const Text('Next Pattern'),
                      ),
                    )
                  : const SizedBox(),
              AppButton(
                onPressed: () => widget.onProceed(TestingState.rhythmicPatterns),
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
