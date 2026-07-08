import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class TwoPDPatternsTester extends StatefulWidget {
  final void Function(String, String) onResponse;
  final StaticPattern currentStaticPattern;
  final int currentItemNo;
  final int totalItemNo;

  const TwoPDPatternsTester({
    super.key,
    required this.onResponse,
    required this.currentStaticPattern,
    required this.currentItemNo,
    required this.totalItemNo,
  });

  @override
  State<TwoPDPatternsTester> createState() => _TwoPDPatternsTesterState();
}

class _TwoPDPatternsTesterState extends State<TwoPDPatternsTester> {
  Timer? _timer;

  // double _calculateAccuracy(String answer) {
  //   return answer == widget.currentStaticPattern.name[0] ? 100 : 0;
  // }

  void _onSubmit(String answer) {
    _timer?.cancel();
    widget.onResponse(widget.currentStaticPattern.name, answer);
  }

  void _sendPattern() {
    String currentPatternString = widget.currentStaticPattern.pattern;
    String data = "";
    switch (widget.currentStaticPattern.fingerNum) {
      case 0:
        data = "<${currentPatternString}000000000000000000000000>";
        break;
      case 1:
        data = "<000000${currentPatternString}000000000000000000>";
        break;
      case 2:
        data = "<000000000000${currentPatternString}000000000000>";
        break;
      case 3:
        data = "<000000000000000000${currentPatternString}000000>";
        break;
      case 4:
        data = "<000000000000000000000000${currentPatternString}>";
        break;
      case 5:
        data = "<$currentPatternString$currentPatternString$currentPatternString$currentPatternString$currentPatternString>";
        break;
      default:
        data = "<$currentPatternString$currentPatternString$currentPatternString$currentPatternString$currentPatternString>";
        break;
    }

    sl<BluetoothBloc>().add(WriteDataEvent(data));
    debugPrint("Pattern sent: $data");
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
  void didUpdateWidget(covariant TwoPDPatternsTester oldWidget) {
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
        const Expanded(
          flex: 2,
          child: Center(
            child: Text(
              "How many points do you feel?",
              style: TextStyle(
                fontFamily: 'Sailec Medium',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: TestingDataProvider.twoPDOptions.map(
              (twoPDOption) {
                return ElevatedButton(
                  onPressed: () => _onSubmit(twoPDOption),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color(0xff128BED),
                    ),
                    elevation: WidgetStateProperty.all<double>(0),
                    // shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(twoPDOption),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
