import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PatternTherapyScreen extends StatefulWidget {
  final BluetoothCharacteristic targetCharacteristic;

  PatternTherapyScreen({required this.targetCharacteristic});

  @override
  _PatternTherapyScreenState createState() => _PatternTherapyScreenState();
}

class _PatternTherapyScreenState extends State<PatternTherapyScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? targetDevice;
  final String targetDeviceName = "Gloves_BLE_01";
  bool isDeviceConnected = false;
  bool isPatternActive = false;
  int? activePattern;
  int patternDelay = 500; // Start with a default delay of 500ms

  @override
  void initState() {
    super.initState();
  }

  void sendPattern(String data) {
    // if (targetCharacteristic == null) return;

    widget.targetCharacteristic!.write(data.codeUnits, withoutResponse: true);
    // print("Pattern sent: $data");
  }

  Timer? _patternTimer; // Timer to handle the looping of patterns

  void startPattern(int pattern) {
    stopPattern(); // Stop any existing patterns before starting a new one
    activePattern = pattern;
    isPatternActive = true;

    // Pattern data and delay configuration
    const Map<int, List<String>> patternData = {
      3: [
        "<027000027000027000027000027000>",
        "<000027000027000027000027000027>",
        "<228000228000228000228000228000>",
        "<000228000228000228000228000228>",
      ],
      4: [
        "<071000071000071000071000071000>",
        "<184000184000184000184000184000>",
        "<000071000071000071000071000071>",
        "<000184000184000184000184000184>",
      ],
      5: [
        "<149149149149149149149149149149>",
        "<106106106106106106106106106106>",
      ],
      6: [
        "<000000000000000000000000000000>",
        "<255255255255255255255255255255>",
      ],
      7: [
        "<009009009009009009009009009009>",
        "<018018018018018018018018018018>",
        "<036036036036036036036036036036>",
        "<192192192192192192192192192192>",
      ],
    };

    _patternTimer =
        Timer.periodic(Duration(milliseconds: patternDelay), (timer) {
      // Adjusted to 500ms
      if (isPatternActive && activePattern == pattern) {
        var currentPatternData = patternData[pattern]!;
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
    // send pattern "<000000000000000000000000000000>"
    sendPattern("<000000000000000000000000000000>");
  }

  @override
  void dispose() {
    _patternTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Device Connector'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Slider(
                value: patternDelay.toDouble(),
                min: 20.0, // Set minimum value to 100ms for the slider
                max: 1000.0, // Set maximum value to 1000ms for the slider
                divisions:
                    10, // This creates 10 discrete divisions in the slider
                label: "$patternDelay ms",
                onChanged: (double value) {
                  setState(() {
                    patternDelay = value.toInt();
                    if (isPatternActive) {
                      // Restart the pattern with the new delay
                      startPattern(activePattern!);
                    }
                  });
                },
              ),
              ElevatedButton(
                onPressed: () => startPattern(3),
                child: Text('Cascade Square Pattern'),
              ),
              ElevatedButton(
                onPressed: () => startPattern(7),
                child: Text('Cascade Pattern'),
              ),
              ElevatedButton(
                onPressed: () => startPattern(4),
                child: Text('Line Pattern'),
              ),
              ElevatedButton(
                onPressed: () => startPattern(5),
                child: Text('Alternate Pattern'),
              ),
              ElevatedButton(
                onPressed: () => startPattern(6),
                child: Text('Blink Pattern'),
              ),
              ElevatedButton(
                onPressed: stopPattern,
                child: Text('Stop Pattern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
