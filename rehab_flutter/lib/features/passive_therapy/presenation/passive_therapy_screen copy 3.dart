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
  late AnimationController _animationController;
  int currentFrame = 0; // Index for the current frame within a pattern.
  Timer? _timer;
  int totalDurationSeconds = 20 * 60; // 20 minutes
  int patternDurationSeconds = 2 * 60; // 2 minutes for each pattern
  int currentPatternIndex = 0; // Index for the current pattern
  int elapsedTimeSeconds = 0; // Time elapsed since the start in seconds
  bool isFirstMinute =
      true; // Flag to check if it's the first minute in the current 2-minute interval

  String accumulatedValues = '';
  // Instantiate PatternBoolsProvider and use the first pattern for demonstration.
  final PatternBoolsProvider patternBoolsProvider = PatternBoolsProvider();
  List<int> sumOneIndices = [0, 1, 4, 5, 8, 9, 12, 13];
  List<int> fingerBool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> values = [1, 8, 1, 8, 2, 16, 2, 16, 4, 3, 4, 3, 64, 128, 64, 128];

  String lastSentPattern = "";
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    updatePattern(currentPatternIndex); // Start with the first pattern
    manageAnimationTiming();
  }

  void manageAnimationTiming() {
    int currentIntervalMilliseconds = 500; // Start with 500ms

    _timer = Timer.periodic(Duration(milliseconds: currentIntervalMilliseconds),
        (timer) {
      setState(() {
        elapsedTimeSeconds +=
            currentIntervalMilliseconds ~/ 1000; // Convert ms to seconds

        // Every minute, check if we need to switch the interval
        if (elapsedTimeSeconds % 60 == 0) {
          isFirstMinute = !isFirstMinute; // Toggle the flag every minute
          currentIntervalMilliseconds = isFirstMinute
              ? 500
              : 250; // 500ms for the first minute, 250ms for the second
          timer.cancel(); // Cancel the current timer
          manageAnimationTiming(); // Restart with the new interval
        }

        // Every 2 minutes, change the pattern
        if (elapsedTimeSeconds % (2 * 60) == 0) {
          currentPatternIndex = (currentPatternIndex + 1) %
              patternBoolsProvider
                  .patternBools.length; // Cycle through patterns
          updatePattern(currentPatternIndex); // Update the pattern
        }

        // Update the UI here as needed
      });

      // If the total time is up, cancel the timer
      if (elapsedTimeSeconds >= totalDurationSeconds) {
        timer.cancel();
      }
    });
  }

  void updatePattern(int index) {
    // Update the current pattern based on the index. Adjust your logic to match your app's needs.
    var pattern = patternBoolsProvider.patternBools[index];
    // Perform any necessary actions to switch to the new pattern
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming you're using the first pattern for demonstration.
    var pattern = patternBoolsProvider.patternBools[0];

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
                  "Total Time Left: ${formatTime(totalDurationSeconds - elapsedTimeSeconds)}"),
              Text(
                  "Pattern Time Left: ${formatTime(patternDurationSeconds - (elapsedTimeSeconds % patternDurationSeconds))}"),
              // Additional UI elements as needed
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

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
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
