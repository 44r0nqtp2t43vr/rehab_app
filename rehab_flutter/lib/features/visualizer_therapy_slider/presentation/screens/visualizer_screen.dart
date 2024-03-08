import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/AudioData.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/RayPainterState.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/Song.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/controllers/bluetooth_controller.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/controllers/helper_functions.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/widgets/circle_painter.dart';
import 'package:rehab_flutter/injection_container.dart';

class VisualizerScreenSlider extends StatefulWidget {
  final Song songData;

  // Constructor
  VisualizerScreenSlider({required this.songData});

  @override
  _VisualizerScreenStateSlider createState() => _VisualizerScreenStateSlider();
}

class _VisualizerScreenStateSlider extends State<VisualizerScreenSlider>
    with SingleTickerProviderStateMixin {
//  controllers
  late AudioPlayer audioPlayer;
  late AnimationController _controller;
  late StreamSubscription? positionSubscription;

  // initial values
  double _totalHeight = 100.0;
  double _totalWidth = 100.0;
  double _circleHeight = 20.0;
  double _circleWidth = 20.0;
  double _rayHeight = -8.0;
  double _rayWidth = 60.0;
  Color _color = Colors.blue;
  bool isPlaying = false;

// list of circles
  List<dynamic> circles = [];

  // AudioData variables
  List<dynamic> blocks = [];
  int currentIndex = -1;
  int prevIndex = -1;

  // Cols
  List<int> firstCol = [0, 4, 8, 12];
  List<int> secondCol = [1, 5, 9, 13];
  List<int> thirdCol = [2, 6, 10, 14];
  List<int> fourthCol = [3, 7, 11, 15];

// Rows
  List<int> firstRow = [0, 1, 2, 3];
  List<int> secondRow = [4, 5, 6, 7];
  List<int> thirdRow = [8, 9, 10, 11];
  List<int> fourthRow = [12, 13, 14, 15];

  // squares
  List<int> firstSquare = [0, 1, 4, 5];
  List<int> secondSquare = [2, 3, 6, 7];
  List<int> thirdSquare = [8, 9, 12, 13];
  List<int> fourthSquare = [10, 11, 14, 15];
  List<int> innerSquare = [5, 6, 9, 10];
  List<int> outerSquare = [0, 1, 2, 3, 4, 7, 8, 11, 12, 13, 14, 15];

  // frequencies
  List<int> bassSquare = [2, 3, 6, 7];
  List<int> midRangeSquare = [9, 10];
  List<int> subBassSquare = [0, 1, 4, 5];
  List<int> lowerMidrangeSquare = [8, 12];
  List<int> presenceSquare = [13, 14];
  List<int> higherMidrangeSquare = [11, 15];

  // actuator vars
  int leftActuatorSum = 0;
  int rightActuatorSum = 0;
  List<int> activeValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  var lastSentPattern;

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
    loadBlocks(widget.songData.metaDataUrl);
    // Subscribe to the onPositionChanged event
    positionSubscription = audioPlayer.onPositionChanged.listen((position) {
      // Find and use the closest block based on the current playback position
      useClosestBlock(
          position.inMilliseconds / 1000.0); // Convert milliseconds to seconds
    });
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
      // 0 for item in ActiveValues
      for (int i = 0; i < activeValues.length; i++) {
        activeValues[i] = 0;
      }

      if (noteOnset == 1 &&
          blocks[prevIndex].noteOnset == 0 &&
          blocks[prevIndex - 1].noteOnset == 0 &&
          blocks[prevIndex - 2].noteOnset == 0 &&
          blocks[prevIndex - 3].noteOnset == 0) {
        for (int i = 0; i < activeValues.length; i++) {
          activeValues[i] = 0;
        }
        int delay = 0; // Initial delay is 0ms for the first column
        List<List<int>> columns = [
          firstCol,
          secondCol,
          thirdCol,
          fourthCol
        ]; // List of column groups for iteration

        for (var column in columns) {
          Timer(Duration(milliseconds: delay), () {
            for (var index in column) {
              // Reset active values before setting the current column as active
              for (int i = 0; i < activeValues.length; i++) {
                activeValues[i] = 0;
              }
              updateCircleState(
                  index, Colors.green, 40.0, 40.0, 1); // Mark as active
            }
          });

          // Increase delay by 200ms for the next column
          delay += 200;
        }

// Schedule the reset to blue for all circles, to happen after the last column has turned green
        Timer(Duration(milliseconds: delay), () {
          resetAllCircles(Colors.blue, 20.0, 20.0, 0); // Mark all as inactive
        });
      } else if (activeValues
          .every((value) => value == 0)) //active values is all 0
      {
        updateCircleProperties(bassSquare, getBoolValue(bass));
        updateCircleProperties(midRangeSquare, getBoolValue(midRange));
        updateCircleProperties(
            lowerMidrangeSquare, getBoolValue(lowerMidrange));
        updateCircleProperties(subBassSquare, getBoolValue(subBass));
        updateCircleProperties(presenceSquare, getBoolValue(presence));
        updateCircleProperties(
            higherMidrangeSquare, getBoolValue(higherMidrange));
      }

      lastSentPattern = sendUpdatedPattern(activeValues, lastSentPattern);
    });

    // Ensure a rebuild to reflect color and size changes
  }

  void updateCircleState(
      int index, Color color, double width, double height, int activeValue) {
    setState(() {
      circles[index].color = color;
      circles[index].circleWidth = width;
      circles[index].circleHeight = height;
      activeValues[index] = activeValue;
    });
    lastSentPattern = sendUpdatedPattern(activeValues, lastSentPattern);
  }

  void resetAllCircles(
      Color color, double width, double height, int activeValue) {
    setState(() {
      for (var circle in circles) {
        circle.color = color;
        circle.circleWidth = width;
        circle.circleHeight = height;
      }
      for (int i = 0; i < activeValues.length; i++) {
        activeValues[i] = activeValue;
      }
    });
  }

  void updateCircleProperties(List<int> squares, bool isActive) {
    final double size = isActive ? 40.0 : 20.0;
    final int activeValue = isActive ? 1 : 0;

    for (int i = 0; i < squares.length; i++) {
      circles[squares[i]].circleWidth = size;
      circles[squares[i]].circleHeight = size;
      activeValues[squares[i]] = activeValue;
    }
  }

  void loadBlocks(String audioData) async {
    String data = await rootBundle.loadString(audioData);
    final List<dynamic> blockJson = json.decode(data);
    blocks = blockJson.map((json) => AudioData.fromJson(json)).toList();
  }

  void togglePlay(String audioFile) async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(AssetSource(audioFile));
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
              onPressed: () => togglePlay(widget.songData.audioUrl),
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
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
}
