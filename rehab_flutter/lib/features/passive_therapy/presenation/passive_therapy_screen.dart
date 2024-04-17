import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/features/passive_therapy/data/pattern_bools_provider.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/helper_functions/bluetooth_functions.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/pattern_bools.dart';
import 'package:rehab_flutter/features/passive_therapy/presenation/widgets/pattern_grid.dart';

class PassiveTherapyScreen extends StatefulWidget {
  final String userId;

  const PassiveTherapyScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  State<PassiveTherapyScreen> createState() => _PassiveTherapyScreenState();
}

class _PassiveTherapyScreenState extends State<PassiveTherapyScreen>
    with TickerProviderStateMixin {
//  PROVIDER
  final PatternBoolsProvider patternBoolsProvider = PatternBoolsProvider();

// COUNTDOWN TIMER
  static int countdownDuration = 90;
  static String countdownText = '1:30';
  Timer? _countdownTimer;
  Duration _duration = Duration(
      seconds:
          countdownDuration); // Initialize the countdown duration to 8 minutes
  String _countdownText = countdownText; // Initial countdown text display

// PATTERN CHANGING
  static int patternChangeDuration = 10;
  static String patternChangeDurationText = '0:10';
  Timer? _patternChangeTimer;
  Duration _patternChangeDuration = Duration(seconds: patternChangeDuration);
  String _patternChangeCountdownText =
      patternChangeDurationText; // Initial text display for pattern change countdown
  int patternIndex = 7;
// ANIMATION SPEED
  static int animationSpeedDuration = 5;
  static String animationSpeedCountdownText = '0:05';
  static int animationSpeedSlow = 500;
  static int animationSpeedFast = 100;
  int _animationSpeed = animationSpeedSlow;
  Timer? _animationSpeedTimer;
  Timer? _animationSpeedChangeTimer;
  Duration _animationSpeedChangeDuration =
      Duration(seconds: animationSpeedDuration);
  String _animationSpeedChangeCountdownText = animationSpeedCountdownText;

// PATTERNS
  late PatternBools pattern;
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
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), _handleCountdown);

    // Animation Speed Timer
    _initializeAnimationSpeedTimer();

    // Animation Speed Change Timer
    _animationSpeedChangeTimer =
        Timer.periodic(const Duration(seconds: 1), _handleAnimationSpeedChange);

    // Pattern Change Timer
    _patternChangeTimer =
        Timer.periodic(const Duration(seconds: 1), _handlePatternChange);
  }

  void _handleCountdown(Timer timer) {
    if (_duration.inSeconds == 0) {
      timer.cancel();
      _cleanupTimers();
      _onEnd();
    } else {
      setState(() {
        _duration -= const Duration(seconds: 1);
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
          Duration(seconds: animationSpeedDuration - 1);
    } else {
      setState(() {
        _animationSpeedChangeDuration -= const Duration(seconds: 1);
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
        _patternChangeDuration -= const Duration(seconds: 1);
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

  void _onEnd() {
    BlocProvider.of<UserBloc>(context).add(SubmitPassiveEvent(widget.userId));
  }

  void _resetPatternChangeTimer() {
    _patternChangeDuration = Duration(seconds: patternChangeDuration - 1);
    _patternChangeCountdownText = _patternChangeCountdownText;
    patternIndex =
        (patternIndex + 1) % patternBoolsProvider.patternBools.length;
    pattern = patternBoolsProvider.patternBools[patternIndex];
    currentFrame = 0; // Reset current frame for the new pattern
  }

  void _toggleAnimationSpeed() {
    // Toggle animation speed between slow and fast, start with slow
    _animationSpeedTimer?.cancel();
    _animationSpeed = _animationSpeed == animationSpeedSlow
        ? animationSpeedFast
        : animationSpeedSlow;
    _animationSpeedChangeDuration =
        Duration(seconds: animationSpeedDuration - 1); // Reset countdown
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
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (previous, current) =>
          previous is UserLoading && current is UserDone,
      listener: (context, state) {
        if (state is UserDone) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lotties/uploading.json',
                width: 400,
                height: 400,
              ),
              //CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        }
        if (state is UserDone) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Passive",
                    style: darkTextTheme().headlineLarge,
                  ),
                  Text(
                    'Passive Therapy',
                    style: darkTextTheme().headlineSmall,
                  ),
                ],
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: const Color(0xff223E64),
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
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
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Pattern Name",
                                  style: TextStyle(
                                    fontFamily: 'Sailec Light',
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  pattern.name,
                                  style: const TextStyle(
                                    fontFamily: 'Sailec Bold',
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Time Remaining',
                              style: TextStyle(
                                fontFamily: 'Sailec Bold',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _countdownText,
                              style: const TextStyle(
                                fontFamily: 'Sailec Bold',
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   'Pattern Change Countdown: $_patternChangeCountdownText',
                        //   style: const TextStyle(
                        //       fontSize: 24, fontWeight: FontWeight.bold),
                        // ),
                        // Text(
                        //   "Speed Countdown: $_animationSpeedChangeCountdownText",
                        //   style: const TextStyle(
                        //       fontSize: 24, fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
