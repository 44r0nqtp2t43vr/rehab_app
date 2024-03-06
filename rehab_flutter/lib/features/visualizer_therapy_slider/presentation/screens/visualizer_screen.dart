import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/audio_data.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/screens/RayPainterState.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/widgets/circle_painter.dart';

class VisualizerScreenSlider extends StatefulWidget {
  @override
  _VisualizerScreenStateSlider createState() => _VisualizerScreenStateSlider();
}

class _VisualizerScreenStateSlider extends State<VisualizerScreenSlider>
    with SingleTickerProviderStateMixin {
  late AudioPlayer audioPlayer;
  late AnimationController _controller;
  double _totalHeight = 100.0;
  double _totalWidth = 100.0;
  double _circleHeight = 20.0;
  double _circleWidth = 20.0;
  double _rayHeight = -8.0;
  double _rayWidth = 60.0;
  Color _color = Colors.blue;
  bool isPlaying = false;
  late StreamSubscription? positionSubscription;
  List<dynamic> circles = [];
  List<dynamic> blocks = [];
  int currentIndex = -1;
  int prevIndex = -1;
  List<int> firstCol = [0, 4, 8, 12];
  List<int> secondCol = [1, 5, 9, 13];
  List<int> thirdCol = [2, 6, 10, 14];
  List<int> fourthCol = [3, 7, 11, 15];
  List<int> firstRow = [0, 1, 2, 3];
  List<int> secondRow = [4, 5, 6, 7];
  List<int> thirdRow = [8, 9, 10, 11];
  List<int> fourthRow = [12, 13, 14, 15];
  List<int> firstSquare = [0, 1, 4, 5];
  List<int> secondSquare = [2, 3, 6, 7];
  List<int> thirdSquare = [8, 9, 12, 13];
  List<int> fourthSquare = [10, 11, 14, 15];
  List<int> innerSquare = [5, 6, 9, 10];
  List<int> outerSquare = [0, 1, 2, 3, 4, 7, 8, 11, 12, 13, 14, 15];
  List<int> bassSquare = [4, 5, 8, 9];
  List<int> midRangeSquare = [6, 7, 10, 11];
  List<int> subBassSquare = [12, 13];
  List<int> lowerMidrangeSquare = [14, 15];
  List<int> presenceSquare = [0, 1];

  List<int> higherMidrangeSquare = [2, 3];
  late Timer _colorChangeTimer; // Timer to periodically change colors
  Color _innerColor = Colors.blue; // Initial color for inner circles
  Color _outerColor = Colors.blueGrey; // Initial color for outer circles
  bool _isInnerColor = true; // Flag to track which color to change

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
    circles = List.generate(16, (index) {
      // Assuming you want 16 blocks as per your UI setup
      return RayPainterState(
        id: '$index',
        progress: _controller.value,
        totalHeight: _totalHeight,
        totalWidth: _totalWidth,
        circleHeight: _circleHeight,
        circleWidth: _circleWidth,
        rayHeight: _rayHeight,
        rayWidth: _rayWidth,
        color: _color,
      );
    });
    _controller.addListener(() {
      setState(() {
        // Update the progress value for each circle
        for (var circle in circles) {
          circle.progress = _controller.value;
        }
      });
    });

    // Load blocks from forest_of_blocks.json
    loadBlocks();
    // Subscribe to the onPositionChanged event
    positionSubscription = audioPlayer.onPositionChanged.listen((position) {
      // Find and use the closest block based on the current playback position
      useClosestBlock(
          position.inMilliseconds / 1000.0); // Convert milliseconds to seconds
    });
    // _colorChangeTimer = Timer.periodic(
    //   Duration(milliseconds: 2000),
    //   (Timer timer) {
    //     setState(() {
    //       if (_isInnerColor) {
    //         // Update colors for inner circles
    //         for (var index in innerSquare) {
    //           circles[index].color =
    //               _innerColor; // Adjust with actual method to set color
    //         }
    //         _innerColor = _innerColor == Colors.blue
    //             ? Colors.blueGrey
    //             : Colors.blue; // Toggle color for next change
    //       } else {
    //         // Update colors for outer circles
    //         for (var index in outerSquare) {
    //           circles[index].color =
    //               _outerColor; // Adjust with actual method to set color
    //         }
    //         _outerColor = _outerColor == Colors.blueGrey
    //             ? Colors.blue
    //             : Colors.blueGrey; // Toggle color for next change
    //       }
    //       _isInnerColor =
    //           !_isInnerColor; // Toggle the flag to change the other set in the next interval
    //     });
    //   },
    // );
  }

  void useClosestBlock(double positionSec) {
    if (blocks.isEmpty) return;

    for (int i = 0; i < blocks.length; i++) {
      if (i == blocks.length - 1 ||
          (blocks[i].time <= positionSec && blocks[i + 1].time > positionSec)) {
        if (i != currentIndex) {
          setState(() {
            prevIndex =
                currentIndex; // Save the current index as previous before updating
            currentIndex = i; // Now update the current index
          });
          break;
        }
      }
    }
    var midRange = blocks[currentIndex].midrange;
    var higherMidrange = blocks[currentIndex].higherMidrange;
    var bass = blocks[currentIndex].bass;
    var subBass = blocks[currentIndex].subBass;
    var lowerMidrange = blocks[currentIndex].lowerMidrange;
    var presence = blocks[currentIndex].presence;

    var noteOnset = blocks[currentIndex].noteOnset;

    setState(() {
      if (noteOnset == 1 &&
          blocks[prevIndex].noteOnset == 0 &&
          blocks[prevIndex - 1].noteOnset == 0 &&
          blocks[prevIndex - 2].noteOnset == 0 &&
          blocks[prevIndex - 3].noteOnset == 0) {
        int delay = 0; // Initial delay is 0ms for the first column

        // List of column groups for iteration
        List<List<int>> columns = [firstCol, secondCol, thirdCol, fourthCol];

        // Iterate over each column group
        for (var column in columns) {
          Timer(Duration(milliseconds: delay), () {
            // Change each circle's color in the current column to green
            for (var index in column) {
              setState(() {
                circles[index].color = Colors.green;
                circles[index].circleWidth = 40.0;
                circles[index].circleHeight = 40.0;
              });
            }
          });

          // Increase delay by 50ms for the next column
          delay += 200;
        }

        // Schedule the reset to blue for all circles, to happen after the last column has turned green
        Timer(Duration(milliseconds: delay), () {
          for (var circle in circles) {
            setState(() {
              circle.color = Colors.blue;
              circle.circleWidth = 20.0;
              circle.circleHeight = 20.0;
            });
          }
        });
      } else {
        if (getBoolValue(bass)) {
          // for every value in bassSquare, circles[bassSquare[i]].color = getColor(bass);
          for (int i = 0; i < bassSquare.length; i++) {
            circles[bassSquare[i]].circleWidth = 40.0;
            circles[bassSquare[i]].circleHeight = 40.0;
          }
        } else {
          for (int i = 0; i < bassSquare.length; i++) {
            circles[bassSquare[i]].circleHeight = 20.0;
            circles[bassSquare[i]].circleWidth = 20.0;
          }
        }

        if (getBoolValue(midRange)) {
          // for every value in bassSquare, circles[bassSquare[i]].color = getColor(bass);
          for (int i = 0; i < bassSquare.length; i++) {
            circles[midRangeSquare[i]].circleWidth = 40.0;
            circles[midRangeSquare[i]].circleHeight = 40.0;
          }
        } else {
          for (int i = 0; i < bassSquare.length; i++) {
            circles[midRangeSquare[i]].circleHeight = 20.0;
            circles[midRangeSquare[i]].circleWidth = 20.0;
          }
        }

        if (getBoolValue(lowerMidrange)) {
          for (int i = 0; i < lowerMidrangeSquare.length; i++) {
            circles[lowerMidrangeSquare[i]].circleWidth = 40.0;
            circles[lowerMidrangeSquare[i]].circleHeight = 40.0;
          }
        } else {
          for (int i = 0; i < lowerMidrangeSquare.length; i++) {
            circles[lowerMidrangeSquare[i]].circleHeight = 20.0;
            circles[lowerMidrangeSquare[i]].circleWidth = 20.0;
          }
        }

        if (getBoolValue(subBass)) {
          for (int i = 0; i < subBassSquare.length; i++) {
            circles[subBassSquare[i]].circleWidth = 40.0;
            circles[subBassSquare[i]].circleHeight = 40.0;
          }
        } else {
          for (int i = 0; i < subBassSquare.length; i++) {
            circles[subBassSquare[i]].circleHeight = 20.0;
            circles[subBassSquare[i]].circleWidth = 20.0;
          }
        }
        if (getBoolValue(presence)) {
          for (int i = 0; i < presenceSquare.length; i++) {
            circles[presenceSquare[i]].circleWidth = 40.0;
            circles[presenceSquare[i]].circleHeight = 40.0;
          }
        } else {
          for (int i = 0; i < presenceSquare.length; i++) {
            circles[presenceSquare[i]].circleHeight = 20.0;
            circles[presenceSquare[i]].circleWidth = 20.0;
          }
        }
        if (getBoolValue(higherMidrange)) {
          for (int i = 0; i < higherMidrangeSquare.length; i++) {
            circles[higherMidrangeSquare[i]].circleWidth = 40.0;
            circles[higherMidrangeSquare[i]].circleHeight = 40.0;
          }
        } else {
          for (int i = 0; i < higherMidrangeSquare.length; i++) {
            circles[higherMidrangeSquare[i]].circleHeight = 20.0;
            circles[higherMidrangeSquare[i]].circleWidth = 20.0;
          }
        }
      }
    });

    // Ensure a rebuild to reflect color and size changes
  }

// Class level variable to track the last switch time

  bool getBoolValue(double value) {
    if (value < 0.2) {
      return false;
    } else {
      return true;
    }
  }

  int getNormalizedValueForMid(double value) {
//  val < 0.2 return 0, if val < 0.4 return 1, until return 4

    if (value < 0.2) {
      return 0;
    } else if (value < 0.4) {
      return 1;
    } else if (value < 0.6) {
      return 2;
    } else if (value < 0.8) {
      return 3;
    } else {
      return 4;
    }
  }

  int getNormalizedValueForTop(double value) {
    //  val < 0.2 return 0, if val < 0.4 return 1, until return 4
    if (value < 0.33) {
      return 0;
    } else if (value < 0.66) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ray Painter Animation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...buildRayPainterRows(),
            ElevatedButton(
              onPressed: togglePlay,
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            buildSlider("Ray Width", _rayWidth, -100, 100, (newValue) {
              setState(() => _rayWidth = newValue);
            }),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRayPainterRows() {
    List<Widget> rows = [];
    int itemsPerRow = 4; // Number of RayPainters per row
    for (int i = 0; i < circles.length; i += itemsPerRow) {
      List<Widget> rowItems = circles
          .sublist(i, min(i + itemsPerRow, circles.length))
          .map((circleState) {
        return Container(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: RayPainter(
              progress: circleState.progress,
              totalHeight: circleState.totalHeight,
              totalWidth: circleState.totalWidth,
              circleHeight: circleState.circleHeight,
              circleWidth: circleState.circleWidth,
              rayHeight: circleState.rayHeight,
              rayWidth: circleState.rayWidth,
              color: circleState.color,
            ),
          ),
        );
      }).toList();
      rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowItems));
    }
    return rows;
  }

  void loadBlocks() async {
    String data =
        await rootBundle.loadString('assets/data/forest_of_blocks.json');
    final List<dynamic> blockJson = json.decode(data);
    blocks = blockJson.map((json) => AudioData.fromJson(json)).toList();
  }

  void togglePlay() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(AssetSource('audio/forestofblocks.mp3'));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    positionSubscription?.cancel();
    // Cancel the subscription to avoid memory leaks
    audioPlayer.dispose();
    super.dispose();
  }
}

double interpolate(
    double input, double inputMax, double max, double median, double min) {
  if (input <= (inputMax / 2)) {
    // Scale input in the range 0 to inputMax/2 to min to median
    return min + (median - min) * (input / (inputMax / 2));
  } else {
    // Scale input in the range inputMax/2 to inputMax to median to max
    return median +
        (max - median) * ((input - (inputMax / 2)) / (inputMax / 2));
  }
}

Color getColor(double higherMidrange) {
  higherMidrange = higherMidrange;
  // Use if-else statements to determine the color
  if (higherMidrange <= 1) {
    return Colors.blue; // Coldest
  } else if (higherMidrange <= 2) {
    return Colors.lightBlue;
  } else if (higherMidrange <= 3) {
    return Colors.cyan;
  } else if (higherMidrange <= 4) {
    return Colors.teal;
  } else if (higherMidrange <= 5) {
    return Colors.green;
  } else if (higherMidrange <= 6) {
    return Colors.lightGreen;
  } else if (higherMidrange <= 7) {
    return Colors.lime;
  } else if (higherMidrange <= 8) {
    return Colors.yellow;
  } else if (higherMidrange <= 9) {
    return Colors.amber;
  } else if (higherMidrange > 9) {
    return Colors.red; // Warmest
  } else {
    return Colors.grey; // Default or error case, should not be reached
  }
}

Widget buildSlider(String label, double value, double min, double max,
    ValueChanged<double> newValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toStringAsFixed(2),
          onChanged: (value) => newValue(value),
        ),
      ],
    ),
  );
}
