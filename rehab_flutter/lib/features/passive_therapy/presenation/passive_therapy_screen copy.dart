import 'dart:async';

import 'package:flutter/material.dart';

class PassiveTherapyScreen extends StatefulWidget {
  const PassiveTherapyScreen({Key? key}) : super(key: key);

  @override
  State<PassiveTherapyScreen> createState() => _PassiveTherapyScreenState();
}

class _PassiveTherapyScreenState extends State<PassiveTherapyScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int currentContainer = 0; // Index for the current container.
  int currentFrame = 0; // Index for the current frame within a container.
  Timer? _timer;
  String accumulatedValues = '';
  // Adjusted to a three-dimensional list.
  List<List<List<int>>> animationBool = [
    [
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1]
    ],
    [
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1]
    ],
    [
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1]
    ],
    [
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1]
    ],
    [
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1]
    ],
    // Add more containers as needed, each with their own sets of frames.
  ];
  List<int> sumOneIndices = [0, 1, 4, 5, 8, 9, 12, 13];
  List<int> fingerBool = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> values = [1, 8, 1, 8, 2, 16, 2, 16, 4, 3, 4, 3, 64, 128, 64, 128];
  double _colorSliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        // Increment the frame within the current container.
        currentFrame =
            (currentFrame + 1) % animationBool[currentContainer].length;
        if (currentFrame == 0) {
          // If we've looped through all frames in the current container,
          // move to the next container.
          currentContainer = (currentContainer + 1) % animationBool.length;
        }

        int sumOne = 0;
        int sumTwo = 0;
        for (int index = 0;
            index < animationBool[currentContainer][currentFrame].length;
            index++) {
          if (animationBool[currentContainer][currentFrame][index] == 1) {
            if (sumOneIndices.contains(index)) {
              sumOne += values[index];
            } else {
              sumTwo += values[index];
            }
          }
        }

        print("sumOne: $sumOne, sumTwo: $sumTwo");
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Adjust the builder to handle multiple containers.
                  for (int containerIndex = 0;
                      containerIndex < animationBool.length;
                      containerIndex++)
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
                          // This logic assumes all containers cycle through their frames in sync.
                          final circleColor = animationBool[containerIndex]
                                      [currentFrame][index] ==
                                  1
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
