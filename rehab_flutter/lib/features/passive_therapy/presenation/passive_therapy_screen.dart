import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/features/passive_therapy/data/pattern_bools_provider.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/helper_functions/bluetooth_functions.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_data.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_therapy_data.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/pattern_bools.dart';
import 'package:rehab_flutter/features/passive_therapy/presenation/widgets/pattern_grid.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';

class PassiveTherapyScreen extends StatefulWidget {
  final PassiveTherapyData data;

  const PassiveTherapyScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<PassiveTherapyScreen> createState() => _PassiveTherapyScreenState();
}

class _PassiveTherapyScreenState extends State<PassiveTherapyScreen> with TickerProviderStateMixin {
//  PROVIDER
  final PatternBoolsProvider patternBoolsProvider = PatternBoolsProvider();

// COUNTDOWN TIMER
  final int countdownDuration = 300;
  final String countdownText = '5:00';
  Timer? _countdownTimer;
  late Duration _duration; // Initialize the countdown duration to 5 minutes
  late String _countdownText; // Initial countdown text display

// PATTERN CHANGING
  final int patternChangeDuration = 120;
  final String patternChangeDurationText = '2:00';
  Timer? _patternChangeTimer;
  late Duration _patternChangeDuration;
  late String _patternChangeCountdownText; // Initial text display for pattern change countdown
  int patternIndex = 7;
// ANIMATION SPEED
  late int animationSpeedDuration;
  //final String animationSpeedCountdownText = '0:05';
  final int animationSpeedSlow = 500;
  final int animationSpeedFast = 100;
  late int _animationSpeed;
  Timer? _animationSpeedTimer;
  Timer? _animationSpeedChangeTimer;
  late Duration _animationSpeedChangeDuration;
  //String _animationSpeedChangeCountdownText = animationSpeedCountdownText;

// PATTERNS
  late PatternBools pattern;
  List<int> sumOneIndices = [0, 1, 4, 5, 8, 9, 12, 13];
  List<int> fingerBool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> values = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
  int currentFrame = 0;

// BLUETOOTH
  String lastSentPattern = '';

  int intensityToAnimationSpeedDuration() {
    switch (widget.data.intensity) {
      case 1:
        return 60;
      case 2:
        return 30;
      case 3:
        return 15;
      case 4:
        return 10;
      case 5:
        return 5;
      default:
        return 60;
    }
  }

  @override
  void initState() {
    super.initState();

    _duration = Duration(seconds: countdownDuration); // Initialize the countdown duration to 8 minutes
    _countdownText = countdownText; // Initial countdown text display

    _patternChangeDuration = Duration(seconds: patternChangeDuration);
    _patternChangeCountdownText = patternChangeDurationText; // Initial text display for pattern change countdown

    animationSpeedDuration = intensityToAnimationSpeedDuration();
    _animationSpeed = animationSpeedSlow;

    _animationSpeedChangeDuration = Duration(seconds: animationSpeedDuration);

    // Initialize pattern based on patternIndex
    pattern = patternBoolsProvider.patternBools[patternIndex];

    // Countdown Timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), _handleCountdown);

    // Animation Speed Timer
    _initializeAnimationSpeedTimer();

    // Animation Speed Change Timer
    _animationSpeedChangeTimer = Timer.periodic(const Duration(seconds: 1), _handleAnimationSpeedChange);

    // Pattern Change Timer
    _patternChangeTimer = Timer.periodic(const Duration(seconds: 1), _handlePatternChange);
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
    _animationSpeedTimer = Timer.periodic(Duration(milliseconds: _animationSpeed), _processAnimation);
  }

  void _handleAnimationSpeedChange(Timer timer) {
    if (_animationSpeedChangeDuration.inSeconds == 0) {
      _toggleAnimationSpeed();
      _initializeAnimationSpeedTimer();
      _animationSpeedChangeDuration = Duration(seconds: animationSpeedDuration - 1);
    } else {
      setState(() {
        _animationSpeedChangeDuration -= const Duration(seconds: 1);
        // _animationSpeedChangeCountdownText =
        //    formatDuration(_animationSpeedChangeDuration);
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

      List<List<int>> sums = calculateSumsForAllFingers(pattern, currentFrame, values, sumOneIndices);
      lastSentPattern = sendPattern(sums[0], sums[1], sums[2], sums[3], sums[4], lastSentPattern);
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
    final currentSession = BlocProvider.of<PatientCurrentSessionBloc>(context).state.currentSession!;

    BlocProvider.of<UserBloc>(context).add(SubmitPassiveEvent(PassiveData(user: widget.data.user, currentSession: currentSession)));

    // final patientPlans = BlocProvider.of<PatientPlansBloc>(context).state.plans;
    // final currentPlan = BlocProvider.of<PatientCurrentPlanBloc>(context).state.currentPlan!;

    // BlocProvider.of<PatientPlansBloc>(context).add(UpdatePatientPlansEvent(patientPlans, currentSession));
    // BlocProvider.of<PatientCurrentPlanBloc>(context).add(UpdateCurrentPlanSessionEvent(currentPlan, currentSession));
  }

  void _resetPatternChangeTimer() {
    _patternChangeDuration = Duration(seconds: patternChangeDuration - 1);
    _patternChangeCountdownText = _patternChangeCountdownText;
    patternIndex = (patternIndex + 1) % patternBoolsProvider.patternBools.length;
    pattern = patternBoolsProvider.patternBools[patternIndex];
    currentFrame = 0; // Reset current frame for the new pattern
  }

  void _toggleAnimationSpeed() {
    // Toggle animation speed between slow and fast, start with slow
    _animationSpeedTimer?.cancel();
    _animationSpeed = _animationSpeed == animationSpeedSlow ? animationSpeedFast : animationSpeedSlow;
    _animationSpeedChangeDuration = Duration(seconds: animationSpeedDuration - 1); // Reset countdown
  }

  @override
  void dispose() {
    _animationSpeedTimer?.cancel();
    _animationSpeedChangeTimer?.cancel();
    _countdownTimer?.cancel();
    _patternChangeTimer?.cancel();
    sendPattern([000, 000], [000, 000], [000, 000], [000, 000], [000, 000], lastSentPattern);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (previous, current) => previous is UserLoading && current is UserDone,
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
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.check,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () => _onEnd(),
                ),
              ],
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
                            PatternGridWidget(patternData: pattern.firstFinger, currentFrame: currentFrame),
                            PatternGridWidget(patternData: pattern.secondFinger, currentFrame: currentFrame),
                            PatternGridWidget(patternData: pattern.thirdFinger, currentFrame: currentFrame),
                            PatternGridWidget(patternData: pattern.fourthFinger, currentFrame: currentFrame),
                            PatternGridWidget(patternData: pattern.fifthFinger, currentFrame: currentFrame),
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
