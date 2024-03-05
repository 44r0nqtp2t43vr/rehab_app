import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Device Connector'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              ...patternProvider.patterns.map((pattern) {
                return PatternButton(
                  buttonText: pattern.name,
                  onPressed: () => startPattern(patternProvider.patterns.indexOf(pattern)),
                );
              }).toList(),
              PatternButton(
                buttonText: 'Stop Pattern',
                onPressed: stopPattern,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
