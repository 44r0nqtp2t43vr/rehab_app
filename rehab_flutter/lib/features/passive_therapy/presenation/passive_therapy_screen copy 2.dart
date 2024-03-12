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
  String accumulatedValues = '';
  // Instantiate PatternBoolsProvider and use the first pattern for demonstration.
  final PatternBoolsProvider patternBoolsProvider = PatternBoolsProvider();
  List<int> sumOneIndices = [0, 1, 4, 5, 8, 9, 12, 13];
  List<int> fingerBool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> values = [1, 8, 1, 8, 2, 16, 2, 16, 4, 3, 4, 3, 64, 128, 64, 128];
  double _colorSliderValue = 0.0;
  String lastSentPattern = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    var pattern = patternBoolsProvider
        .patternBools[0]; // Assuming the first pattern is used.

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        currentFrame = (currentFrame + 1) %
            pattern.firstFinger
                .length; // Assuming all fingers have the same number of frames.

        // Calculate sums for each finger
        List<int> sumsFirstFinger = calculateSums(
            pattern.firstFinger, currentFrame, values, sumOneIndices);
        List<int> sumsSecondFinger = calculateSums(
            pattern.secondFinger, currentFrame, values, sumOneIndices);
        List<int> sumsThirdFinger = calculateSums(
            pattern.thirdFinger, currentFrame, values, sumOneIndices);
        List<int> sumsFourthFinger = calculateSums(
            pattern.fourthFinger, currentFrame, values, sumOneIndices);
        List<int> sumsFifthFinger = calculateSums(
            pattern.fifthFinger, currentFrame, values, sumOneIndices);

        // sendPattern(sumsFirstFinger, sumsSecondFinger, sumsThirdFinger,
        //     sumsFourthFinger, sumsFifthFinger);
        // Print the sums for all fingers
        print(
            "finger1: sum1: ${sumsFirstFinger[0]}, sum2: ${sumsFirstFinger[1]}, "
            "finger2: sum1: ${sumsSecondFinger[0]}, sum2: ${sumsSecondFinger[1]}, "
            "finger3: sum1: ${sumsThirdFinger[0]}, sum2: ${sumsThirdFinger[1]}, "
            "finger4: sum1: ${sumsFourthFinger[0]}, sum2: ${sumsFourthFinger[1]}, "
            "finger5: sum1: ${sumsFifthFinger[0]}, sum2: ${sumsFifthFinger[1]}");
      });
    });
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
}
