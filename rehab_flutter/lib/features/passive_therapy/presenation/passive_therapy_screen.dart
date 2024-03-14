import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/passive_therapy/data/pattern_bools_provider.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/helper_functions/bluetooth_functions.dart';
import 'package:rehab_flutter/features/passive_therapy/presenation/widgets/pattern_grid.dart';
import 'package:rehab_flutter/injection_container.dart';

class PassiveTherapyScreen extends StatefulWidget {
  const PassiveTherapyScreen({Key? key}) : super(key: key);

  @override
  State<PassiveTherapyScreen> createState() => _PassiveTherapyScreenState();
}

class _PassiveTherapyScreenState extends State<PassiveTherapyScreen>
    with TickerProviderStateMixin {
//  PROVIDER
  final PatternBoolsProvider patternBoolsProvider = PatternBoolsProvider();

// COUNTDOWN TIMER
  static int COUNTDOWN_DURATION = 20;
  static String COUNTDOWN_TEXT = '20:00';
  Timer? _countdownTimer;
  Duration _duration = Duration(
      minutes:
          COUNTDOWN_DURATION); // Initialize the countdown duration to 8 minutes
  String _countdownText = COUNTDOWN_TEXT; // Initial countdown text display

// PATTERN CHANGING
  static int PATTERN_CHANGE_DURATION = 60;
  static String PATTERN_CHANGE_COUNTDOWN_TEXT = '1:00';
  Timer? _patternChangeTimer;
  Duration _patternChangeDuration = Duration(seconds: PATTERN_CHANGE_DURATION);
  String _patternChangeCountdownText =
      PATTERN_CHANGE_COUNTDOWN_TEXT; // Initial text display for pattern change countdown
  int patternIndex = 0;

// ANIMATION SPEED
  static int ANIMATION_SPEED_DURATION = 30;
  static String ANIMATION_SPEED_COUNTDOWN_TEXT = '0:30';
  static int ANIMATION_SPEED_SLOW = 500;
  static int ANIMATION_SPEED_FAST = 100;
  int _animationSpeed = ANIMATION_SPEED_SLOW;
  Timer? _animationSpeedTimer;
  Timer? _animationSpeedChangeTimer;
  Duration _animationSpeedChangeDuration =
      Duration(seconds: ANIMATION_SPEED_DURATION);
  String _animationSpeedChangeCountdownText = ANIMATION_SPEED_COUNTDOWN_TEXT;

// PATTERNS
  late var pattern;
  List<int> sumOneIndices = [0, 1, 4, 5, 8, 9, 12, 13];
  List<int> fingerBool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> values = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
  int currentFrame = 0;

// BLUETOOTH
  String lastSentPattern = '';

  @override
  void initState() {
    super.initState();

    // Initialize pattern based on patternIndex
    pattern = patternBoolsProvider.patternBools[patternIndex];

    // Countdown Timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), _handleCountdown);

    // Animation Speed Timer
    _initializeAnimationSpeedTimer();

    // Animation Speed Change Timer
    _animationSpeedChangeTimer =
        Timer.periodic(Duration(seconds: 1), _handleAnimationSpeedChange);

    // Pattern Change Timer
    _patternChangeTimer =
        Timer.periodic(Duration(seconds: 1), _handlePatternChange);
  }

  void _handleCountdown(Timer timer) {
    if (_duration.inSeconds == 0) {
      timer.cancel();
      _cleanupTimers();
    } else {
      setState(() {
        _duration -= Duration(seconds: 1);
        _countdownText = formatDuration(_duration);
      });
    }
  }

  void _initializeAnimationSpeedTimer() {
    _animationSpeedTimer?.cancel();
    _animationSpeedTimer = Timer.periodic(
        Duration(milliseconds: _animationSpeed), _processAnimation);
  }

  void _handleAnimationSpeedChange(Timer timer) {
    if (_animationSpeedChangeDuration.inSeconds == 0) {
      _toggleAnimationSpeed();
      _initializeAnimationSpeedTimer();
      _animationSpeedChangeDuration =
          Duration(seconds: ANIMATION_SPEED_DURATION - 1);
    } else {
      setState(() {
        _animationSpeedChangeDuration -= Duration(seconds: 1);
        _animationSpeedChangeCountdownText =
            formatDuration(_animationSpeedChangeDuration);
      });
    }
  }

  void _handlePatternChange(Timer timer) {
    setState(() {
      if (_patternChangeDuration.inSeconds == 0) {
        _resetPatternChangeTimer();
      } else {
        _patternChangeDuration -= Duration(seconds: 1);
        _patternChangeCountdownText = formatDuration(_patternChangeDuration);
      }
    });
  }

  void _processAnimation(Timer timer) {
    // Assuming 'pattern.firstFinger.length' is valid and initialized
    setState(() {
      int length = pattern.firstFinger.length;
      currentFrame = (currentFrame + 1) % length;

      List<List<int>> sums = calculateSumsForAllFingers(
          pattern, currentFrame, values, sumOneIndices);
      lastSentPattern = sendPattern(
          sums[0], sums[1], sums[2], sums[3], sums[4], lastSentPattern);
    });
    // _printFingerSums(sums);
    // Additional logic to update the animation based on the current frame
  }

  void _cleanupTimers() {
    _animationSpeedTimer?.cancel();
    _patternChangeTimer?.cancel();
    _animationSpeedChangeTimer?.cancel();
  }

  void _resetPatternChangeTimer() {
    _patternChangeDuration = Duration(seconds: PATTERN_CHANGE_DURATION - 1);
    _patternChangeCountdownText = PATTERN_CHANGE_COUNTDOWN_TEXT;
    patternIndex =
        (patternIndex + 1) % patternBoolsProvider.patternBools.length;
    pattern = patternBoolsProvider.patternBools[patternIndex];
    currentFrame = 0; // Reset current frame for the new pattern
  }

  void _toggleAnimationSpeed() {
    // Toggle animation speed between slow and fast, start with slow
    _animationSpeedTimer?.cancel();
    _animationSpeed = _animationSpeed == ANIMATION_SPEED_SLOW
        ? ANIMATION_SPEED_FAST
        : ANIMATION_SPEED_SLOW;
    _animationSpeedChangeDuration =
        Duration(seconds: ANIMATION_SPEED_DURATION - 1); // Reset countdown
  }

  @override
  void dispose() {
    _animationSpeedTimer?.cancel();
    _animationSpeedChangeTimer?.cancel();
    _countdownTimer?.cancel();
    _patternChangeTimer?.cancel();
    sendPattern([000, 000], [000, 000], [000, 000], [000, 000], [000, 000],
        lastSentPattern);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Squares Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Countdown: $_countdownText',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Pattern Change Countdown: $_patternChangeCountdownText',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Speed Countdown: $_animationSpeedChangeCountdownText",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text("Pattern Name: ${pattern.name}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Example for displaying the first finger's frames.
                  // Extend this for additional fingers as needed.
                  PatternGridWidget(
                      patternData: pattern.firstFinger,
                      currentFrame: currentFrame),
                  PatternGridWidget(
                      patternData: pattern.secondFinger,
                      currentFrame: currentFrame),
                  PatternGridWidget(
                      patternData: pattern.thirdFinger,
                      currentFrame: currentFrame),
                  PatternGridWidget(
                      patternData: pattern.fourthFinger,
                      currentFrame: currentFrame),
                  PatternGridWidget(
                      patternData: pattern.fifthFinger,
                      currentFrame: currentFrame),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
