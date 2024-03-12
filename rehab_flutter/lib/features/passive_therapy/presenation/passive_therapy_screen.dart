import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/passive_therapy/data/pattern_bools_provider.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/pattern_bools.dart';
import 'package:rehab_flutter/injection_container.dart';

class PassiveTherapyScreen extends StatefulWidget {
  const PassiveTherapyScreen({Key? key}) : super(key: key);

  @override
  State<PassiveTherapyScreen> createState() => _PassiveTherapyScreenState();
}

class _PassiveTherapyScreenState extends State<PassiveTherapyScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _timer;
  Timer? _totalTimer;
  int totalTime = 20 * 60; // 20 minutes in seconds
  int patternTime = 2 * 60; // 2 minutes in seconds
  String currentPatternName = "";

  int currentFrame = 0; // Index for the current frame within a pattern.

  String accumulatedValues = '';
  // Instantiate PatternBoolsProvider and use the first pattern for demonstration.
  final PatternBoolsProvider patternBoolsProvider = PatternBoolsProvider();
  List<int> sumOneIndices = [0, 1, 4, 5, 8, 9, 12, 13];
  List<int> fingerBool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> values = [1, 8, 1, 8, 2, 16, 2, 16, 4, 3, 4, 3, 64, 128, 64, 128];
  double _colorSliderValue = 0.0;
  double elapsedTime = 0; // Total elapsed time in seconds, as double
  String lastSentPattern = "";
  int patternIndex = 0; // Index for the current pattern

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    int patternIndex = 0;
    updatePatternInfo(patternIndex); // Start with the first pattern
    startTimer();
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        elapsedTime += 0.5; // Increment by 0.5 seconds for each 500ms tick
        if (elapsedTime >= patternTime) {
          patternIndex =
              (patternIndex + 1) % patternBoolsProvider.patternBools.length;
          updatePatternInfo(
              patternIndex); // Update the pattern based on the new index
          elapsedTime = 0; // Reset elapsed time for the new pattern
          patternTime = 2 * 60; // Reset time for the next pattern
        }

        // Perform any updates that need to happen every tick here
      });

      if (totalTime <= 0) {
        _timer?.cancel(); // Stop the timer when total time runs out
      }
    });
  }

  void updatePatternInfo(int patternIndex) {
    var pattern = patternBoolsProvider.patternBools[patternIndex];
    currentPatternName = pattern.name;
    // Perform any additional setup or initialization for the new pattern here
  }

  void updateTimeDisplay() {
    // This method updates the display elements for time and pattern name.
    // Since setState is called in the timer's callback, the UI will automatically update.
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

  // Method to calculate the sums of left and right actuator buttons

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

// Ensure to dispose of the timer
  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
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
              Text("Total Time Left: ${formatTime(totalTime)}"),
              Text("Time for Current Pattern: ${formatTime(patternTime)}"),
              Text("Current Pattern: $currentPatternName"),
              // Example for displaying the first finger's frames.
              // Extend this for additional fingers as needed.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

  String formatTime(int seconds) {
    // Helper function to format the time from seconds to MM:SS format
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
}
