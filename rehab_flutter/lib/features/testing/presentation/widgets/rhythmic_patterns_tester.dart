import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class RhythmicPatternsTester extends StatefulWidget {
  final void Function(double) onResponse;
  final RhythmicPattern currentRhythmicPattern;
  final int currentItemNo;
  final int totalItemNo;

  const RhythmicPatternsTester({
    super.key,
    required this.onResponse,
    required this.currentRhythmicPattern,
    required this.currentItemNo,
    required this.totalItemNo,
  });

  @override
  State<RhythmicPatternsTester> createState() => _RhythmicPatternsTesterState();
}

class _RhythmicPatternsTesterState extends State<RhythmicPatternsTester> {
  final int patternDelay = 500;
  Timer? _patternTimer;

  void sendPattern(String data) {
    sl<BluetoothBloc>().add(WriteDataEvent(data));
  }

  void startPattern() {
    _patternTimer = Timer.periodic(Duration(milliseconds: patternDelay), (timer) {
      sendPattern(widget.currentRhythmicPattern.pattern[timer.tick % widget.currentRhythmicPattern.pattern.length]);
    });
  }

  void stopPattern() {
    _patternTimer?.cancel();
    sendPattern("<000000000000000000000000000000>");
  }

  void _onSubmit(String value) {
    stopPattern();
    widget.onResponse(value == widget.currentRhythmicPattern.name ? 100 : 0);
  }

  @override
  void initState() {
    super.initState();
    startPattern();
  }

  @override
  void didUpdateWidget(covariant RhythmicPatternsTester oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentRhythmicPattern != oldWidget.currentRhythmicPattern) {
      startPattern();
    }
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        TestLabel(label: "Item ${widget.currentItemNo} of ${widget.totalItemNo}"),
        const SizedBox(height: 16),
        const Expanded(
          flex: 2,
          child: Center(
            child: Text(
              "What pattern do you feel?",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: TestingDataProvider.rhythmicPatterns.map(
              (rhythmicPattern) {
                return ElevatedButton(
                  onPressed: () => _onSubmit(rhythmicPattern.name),
                  child: Text(rhythmicPattern.name),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
