import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/actuator_display_grid.dart';
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
  bool isLeftHand = true;
  bool isDeviceConnected = false;
  bool isPatternActive = false;
  int? activePattern;
  int patternDelay = 500; // Start with a default delay of 500ms
  Timer? _patternTimer; // Timer to handle the looping of patterns
  PatternProvider patternProvider = PatternProvider();

  @override
  void initState() {
    super.initState();
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
        sendPattern(currentPatternData[timer.tick % currentPatternData.length]);
      } else {
        timer.cancel();
      }
    });
  }

  void stopPattern() {
    isPatternActive = false;
    activePattern = null;
    _patternTimer?.cancel();
    sendPattern("<000000000000000000000000000000>");
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 28),
            Container(
              height: screenWidth,
              width: double.infinity,
              color: Colors.black,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ActuatorDisplayGrid(
                              size: gridSize,
                              patternData: const [
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ]
                              ],
                              currentFrame: 0,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isLeftHand ? "Pinky" : "Thumb",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ActuatorDisplayGrid(
                              size: gridSize,
                              patternData: const [
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ]
                              ],
                              currentFrame: 0,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isLeftHand ? "Ring" : "Index",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ActuatorDisplayGrid(
                              size: gridSize,
                              patternData: const [
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ]
                              ],
                              currentFrame: 0,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Middle",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ActuatorDisplayGrid(
                              size: gridSize,
                              patternData: const [
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ]
                              ],
                              currentFrame: 0,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isLeftHand ? "Index" : "Ring",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ActuatorDisplayGrid(
                              size: gridSize,
                              patternData: const [
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ]
                              ],
                              currentFrame: 0,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isLeftHand ? "Thumb" : "Pinky",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                ...patternProvider.patterns.map((pattern) {
                  return PatternButton(
                    buttonText: pattern.name,
                    onPressed: () => startPattern(patternProvider.patterns.indexOf(pattern)),
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 28),
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
            const SizedBox(height: 28),
            PatternButton(
              buttonText: 'Stop Pattern',
              onPressed: stopPattern,
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cutaneous",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
          Text(
            "Pattern Therapy",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: IconButton(
            icon: isLeftHand
                ? const Icon(
                    Icons.back_hand,
                    color: Colors.white,
                  )
                : Transform(
                    transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                    child: const Icon(
                      Icons.back_hand,
                      color: Colors.white,
                    ),
                  ),
            onPressed: () => _onHandButtonPressed(),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  void _onHandButtonPressed() {
    setState(() {
      isLeftHand = !isLeftHand;
    });
  }
}
