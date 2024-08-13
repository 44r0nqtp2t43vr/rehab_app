import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/actuators_display_container.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/pattern_button.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/pattern_slider.dart';
import 'package:rehab_flutter/injection_container.dart';
import 'package:rehab_flutter/features/pattern_therapy/data/pattern_provider.dart';

class PatternTherapy extends StatefulWidget {
  const PatternTherapy({Key? key}) : super(key: key);

  @override
  State<PatternTherapy> createState() => _PatternTherapyState();
}

class _PatternTherapyState extends State<PatternTherapy> {
  bool isLeftHand = false;
  bool isDeviceConnected = false;
  bool isPatternActive = false;
  int? activePattern;
  int patternDelay = 500; // Start with a default delay of 500ms
  Timer? _patternTimer; // Timer to handle the looping of patterns
  List<bool> circleStates = List.generate(16, (_) => false);
  PatternProvider patternProvider = PatternProvider();

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

  void sendPattern(String data) {
    sl<BluetoothBloc>().add(WriteDataEvent(data));
  }

  void startPattern(int patternIndex) {
    stopPattern(); // Stop any existing patterns before starting a new one
    activePattern = patternIndex;
    isPatternActive = true;

    // Assuming patternProvider is accessible here, if not, it should be passed as a parameter or made globally accessible
    var currentPatternData = patternProvider.patterns[patternIndex].patternData;

    _patternTimer = Timer.periodic(Duration(milliseconds: patternDelay), (timer) {
      // Adjusted to 500ms or as per the requirement
      if (isPatternActive && activePattern == patternIndex) {
        final String patternToSend = currentPatternData[timer.tick % currentPatternData.length];
        setState(() {
          circleStates = patternToCircleStates(patternToSend);
        });
        sendPattern(patternToSend);
      } else {
        timer.cancel();
      }
    });
  }

  void stopPattern() {
    isPatternActive = false;
    activePattern = null;
    _patternTimer?.cancel();
    setState(() {
      circleStates = List.generate(16, (_) => false);
    });
    sendPattern("<000000000000000000000000000000>");
  }

  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      //appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 12, right: 24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cutaneous',
                          style: darkTextTheme().headlineLarge,
                        ),
                        Text(
                          "Pattern Discrimination",
                          style: darkTextTheme().headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: isLeftHand ? const Color(0xff128BED) : const Color(0xff01FF99),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: isLeftHand
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                              child: const Icon(
                                Icons.back_hand,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.back_hand,
                              color: isLeftHand ? Colors.white : const Color(0xff275492),
                            ),
                      onPressed: () => _onHandButtonPressed(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ActuatorsDisplayContainer(
                      height: screenWidth,
                      gridSize: gridSize,
                      isLeftHand: isLeftHand,
                      circleStates: circleStates,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        ...patternProvider.patterns.map((pattern) {
                          final isActive = activePattern == patternProvider.patterns.indexOf(pattern);
                          return PatternButton(
                            buttonText: pattern.name,
                            onPressed: () => startPattern(patternProvider.patterns.indexOf(pattern)),
                            isActive: isActive,
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    PatternDelaySlider(
                      patternDelay: patternDelay.toDouble(),
                      onDelayChanged: (double value) {
                        setState(() {
                          patternDelay = value.toInt();
                          if (isPatternActive) {
                            startPattern(activePattern!);
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.stop_circle_fill,
                        size: 80,
                        color: Colors.white,
                      ),
                      onPressed: stopPattern,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onHandButtonPressed() {
    setState(() {
      isLeftHand = !isLeftHand;
    });
  }
}
