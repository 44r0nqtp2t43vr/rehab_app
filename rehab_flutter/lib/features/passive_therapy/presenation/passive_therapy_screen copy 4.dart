import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/passive_therapy/data/pattern_bools_provider.dart';
import 'package:rehab_flutter/injection_container.dart';

class PassiveTherapyScreen extends StatefulWidget {
  const PassiveTherapyScreen({Key? key}) : super(key: key);

  @override
  State<PassiveTherapyScreen> createState() => _PassiveTherapyScreenState();
}

class _PassiveTherapyScreenState extends State<PassiveTherapyScreen>
    with TickerProviderStateMixin {
  int currentFrame = 0; // Index for the current frame within a pattern.
  Timer? _animationSpeedTimer;
  String accumulatedValues = '';
  // Instantiate PatternBoolsProvider and use the first pattern for demonstration.
  final PatternBoolsProvider patternBoolsProvider = PatternBoolsProvider();
  List<int> sumOneIndices = [0, 1, 4, 5, 8, 9, 12, 13];
  List<int> fingerBool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> values = [1, 8, 1, 8, 2, 16, 2, 16, 4, 3, 4, 3, 64, 128, 64, 128];

  String lastSentPattern = "";

  Timer? _countdownTimer;
  Duration _duration =
      Duration(minutes: 20); // Initialize the countdown duration to 8 minutes
  String _countdownText = '20:00'; // Initial countdown text display
  int patternIndex = 1;

  Duration _patternChangeDuration = Duration(minutes: 2);
  String _patternChangeCountdownText =
      '02:00'; // Initial text display for pattern change countdown

  int _animationSpeed = 500; // Start with 500ms

  Timer? _toggleSpeedTimer;
  late var pattern;

  String _speedToggleCountdownText =
      '01:00'; // Initial countdown text for speed toggle
  Duration _speedToggleDuration =
      Duration(seconds: 60); // Duration until the next speed toggle
  Timer?
      _speedToggleCountdownTimer; // Timer to update the speed toggle countdown text

  @override
  void initState() {
    super.initState();

    // Initialize pattern based on patternIndex
    pattern = patternBoolsProvider.patternBools[patternIndex];

// // // // // // // //
// COUNTDOWN TIMER //
// // // // // // //
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        timer.cancel();

        _animationSpeedTimer?.cancel();
      } else {
        setState(() {
          _duration = _duration - Duration(seconds: 1);
          _countdownText =
              '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';
        });
      }
    });

    // _initializeSpeedToggleCountdown();

    // // Timer that toggles the speed every 60 seconds
    // _toggleSpeedTimer = Timer.periodic(Duration(seconds: 60), (timer) {
    //   // Toggle speed between 500ms and 2000ms
    //   _animationSpeed = (_animationSpeed == 500) ? 2000 : 500;

    //   // Restart the animation speed timer with the new speed
    //   _animationSpeedTimer?.cancel(); // Cancel the existing timer
    //   _initializeAnimationSpeedTimer(); // Reinitialize with new speed

    //   // Reset the speed toggle countdown
    //   _speedToggleDuration = Duration(seconds: 60);
    //   _speedToggleCountdownText = '01:00';
    // });

// // // // // // // // //
// PATTERN CHANGE TIMER //
// // // // // // // // //
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     if (_patternChangeDuration.inSeconds == 0) {
    //       _patternChangeDuration = Duration(minutes: 2); // Reset countdown
    //       _patternChangeCountdownText = '2:00'; // Reset countdown text
    //       patternIndex =
    //           (patternIndex + 1) % patternBoolsProvider.patternBools.length;
    //       // Update pattern to the new patternIndex
    //       pattern = patternBoolsProvider.patternBools[patternIndex];
    //       // Reset currentFrame to start the new pattern from its beginning
    //       currentFrame = 0;
    //     } else {
    //       _patternChangeDuration =
    //           _patternChangeDuration - Duration(seconds: 1);
    //       _patternChangeCountdownText =
    //           '${_patternChangeDuration.inMinutes.toString().padLeft(2, '0')}:${(_patternChangeDuration.inSeconds % 60).toString().padLeft(2, '0')}';
    //     }
    //   });
    // });
  }

  void _initializeSpeedToggleCountdown() {
    _speedToggleCountdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_speedToggleDuration.inSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _speedToggleDuration = _speedToggleDuration - Duration(seconds: 1);
          _speedToggleCountdownText =
              '${_speedToggleDuration.inMinutes.toString().padLeft(2, '0')}:${(_speedToggleDuration.inSeconds % 60).toString().padLeft(2, '0')}';
        });
      }
    });
  }

  void _initializeAnimationSpeedTimer() {
    _animationSpeedTimer =
        Timer.periodic(Duration(milliseconds: _animationSpeed), (timer) {
      setState(() {
        // Assuming 'pattern.firstFinger.length' is a valid and initialized list
        int length = pattern.firstFinger.length;
        currentFrame = (currentFrame + 1) % length;
        // Additional logic to update the animation based on the current frame
      });
    });
  }

  @override
  void dispose() {
    _animationSpeedTimer?.cancel();
    _countdownTimer?.cancel();
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
                'Speed Toggle Countdown: $_speedToggleCountdownText',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Example for displaying the first finger's frames.
                  // Extend this for additional fingers as needed.
                  Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 16, // Assuming all frames have 16 elements.
                      itemBuilder: (context, index) {
                        final circleColor =
                            pattern.firstFinger[currentFrame][index] == 1
                                ? Colors.red
                                : Colors.white;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 16, // Assuming all frames have 16 elements.
                      itemBuilder: (context, index) {
                        final circleColor =
                            pattern.secondFinger[currentFrame][index] == 1
                                ? Colors.red
                                : Colors.white;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 16, // Assuming all frames have 16 elements.
                      itemBuilder: (context, index) {
                        final circleColor =
                            pattern.thirdFinger[currentFrame][index] == 1
                                ? Colors.red
                                : Colors.white;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 16, // Assuming all frames have 16 elements.
                      itemBuilder: (context, index) {
                        final circleColor =
                            pattern.fourthFinger[currentFrame][index] == 1
                                ? Colors.red
                                : Colors.white;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 16, // Assuming all frames have 16 elements.
                      itemBuilder: (context, index) {
                        final circleColor =
                            pattern.fifthFinger[currentFrame][index] == 1
                                ? Colors.red
                                : Colors.white;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void printsums(
      List<int> sumsFirstFinger,
      List<int> sumsSecondFinger,
      List<int> sumsThirdFinger,
      List<int> sumsFourthFinger,
      List<int> sumsFifthFinger) {
    return print(
        "finger1: sum1: ${sumsFirstFinger[0]}, sum2: ${sumsFirstFinger[1]}, "
        "finger2: sum1: ${sumsSecondFinger[0]}, sum2: ${sumsSecondFinger[1]}, "
        "finger3: sum1: ${sumsThirdFinger[0]}, sum2: ${sumsThirdFinger[1]}, "
        "finger4: sum1: ${sumsFourthFinger[0]}, sum2: ${sumsFourthFinger[1]}, "
        "finger5: sum1: ${sumsFifthFinger[0]}, sum2: ${sumsFifthFinger[1]}");
  }

  void sendPattern(List<int> first, List<int> second, List<int> third,
      List<int> fourth, List<int> fifth) {
    String firstLeft = first[0].toString().padLeft(3, '0');
    String firstRight = first[1].toString().padLeft(3, '0');
    String secondLeft = second[0].toString().padLeft(3, '0');
    String secondRight = second[1].toString().padLeft(3, '0');
    String thirdLeft = third[0].toString().padLeft(3, '0');
    String thirdRight = third[1].toString().padLeft(3, '0');
    String fourthLeft = fourth[0].toString().padLeft(3, '0');
    String fourthRight = fourth[1].toString().padLeft(3, '0');
    String fifthLeft = fifth[0].toString().padLeft(3, '0');
    String fifthRight = fifth[1].toString().padLeft(3, '0');
    String data =
        "<$firstLeft$firstRight$secondLeft$secondRight$thirdLeft$thirdRight$fourthLeft$fourthRight$fifthLeft$fifthRight>";

    // Check if the data to be sent is different from the last sent pattern
    if (data != lastSentPattern) {
      sl<BluetoothBloc>().add(WriteDataEvent(data));
      debugPrint("Pattern sent: $data");
      lastSentPattern = data; // Update the last sent pattern
    } else {
      debugPrint("Pattern not sent, identical to last pattern.");
    }
  }

  void printSums(List<List<int>> sums) {
    for (int i = 0; i < sums.length; i++) {
      print("Finger ${i + 1}: sum1: ${sums[i][0]}, sum2: ${sums[i][1]}");
    }
  }

  List<int> calculateSums(List<List<int>> fingerPatterns, int currentFrame,
      List<int> values, List<int> sumOneIndices) {
    int sumOne = 0;
    int sumTwo = 0;
    for (int index = 0; index < fingerPatterns[currentFrame].length; index++) {
      if (fingerPatterns[currentFrame][index] == 1) {
        if (sumOneIndices.contains(index)) {
          sumOne += values[index];
        } else {
          sumTwo += values[index];
        }
      }
    }
    return [sumOne, sumTwo];
  }
}
