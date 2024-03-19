import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/controllers/bluetooth_controller.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/audio_data.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/ray_painter_state.dart';

import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/controllers/helper_functions.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/widgets/circle_painter.dart';

class VisualizerScreenSlider extends StatefulWidget {
  final Song songData;

  // Constructor
  const VisualizerScreenSlider({super.key, required this.songData});

  @override
  VisualizerScreenStateSlider createState() => VisualizerScreenStateSlider();
}

class VisualizerScreenStateSlider extends State<VisualizerScreenSlider> with SingleTickerProviderStateMixin {
//  controllers
  late AudioPlayer audioPlayer;
  late AnimationController _controller;
  late StreamSubscription? positionSubscription;

  // initial values
  final double _totalHeight = 100.0;
  final double _totalWidth = 100.0;
  final double _circleHeight = 20.0;
  final double _circleWidth = 20.0;
  final double _rayHeight = -8.0;
  final double _rayWidth = 60.0;
  final Color _color = Colors.blue;
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
  List<int> subBassSquare = [1, 4];
  List<int> lowerMidrangeSquare = [8, 12];
  List<int> presenceSquare = [13, 14];
  List<int> higherMidrangeSquare = [11, 15];
  List<int> brillianceSquare = [0, 5];

  // actuator vars
  int leftActuatorSum = 0;
  int rightActuatorSum = 0;
  List<int> activeValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  Map<String, int> lastSentPattern = {};
  double currentPositionSec = 0.0;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
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
      setState(() {
        currentPositionSec = position.inSeconds.toDouble();
      });

      useClosestBlock(position.inMilliseconds / 1000.0); // Convert milliseconds to seconds
    });
  }

  void useClosestBlock(double positionSec) {
    if (blocks.isEmpty) return;

    for (int i = 0; i < blocks.length; i++) {
      if (i == blocks.length - 1 || (blocks[i].time <= positionSec && blocks[i + 1].time > positionSec)) {
        if (i != currentIndex) {
          setState(() {
            prevIndex = currentIndex; // Save the current index as previous before updating
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
    var brilliance = blocks[currentIndex].brilliance;

    setState(() {
      // 0 for item in ActiveValues
      for (int i = 0; i < activeValues.length; i++) {
        activeValues[i] = 0;
      }
      print("Time: ${blocks[currentIndex].time}");
      print("Position: $positionSec");

      if (noteOnset == 1 && blocks[prevIndex].noteOnset == 0 && blocks[prevIndex - 1].noteOnset == 0 && blocks[prevIndex - 2].noteOnset == 0 && blocks[prevIndex - 3].noteOnset == 0) {
        for (int i = 0; i < activeValues.length; i++) {
          activeValues[i] = 0;
        }
        int delay = 0; // Initial delay is 0ms for the first column
        List<List<int>> columns = [firstCol, secondCol, thirdCol, fourthCol]; // List of column groups for iteration

        for (var column in columns) {
          Timer(Duration(milliseconds: delay), () {
            for (var index in column) {
              // Reset active values before setting the current column as active
              for (int i = 0; i < activeValues.length; i++) {
                activeValues[i] = 0;
              }
              updateCircleState(index, Colors.green, 40.0, 40.0, 1); // Mark as active
            }
          });

          // Increase delay by 200ms for the next column
          delay += 200;
        }
        print(noteOnset);
// Schedule the reset to blue for all circles, to happen after the last column has turned green
        Timer(Duration(milliseconds: delay), () {
          resetAllCircles(Colors.blue, 20.0, 20.0, 0); // Mark all as inactive
        });
      } else if (noteOnset == 1) {
        updateCirclePropertiesNoteOnset(outerSquare, true);
        lastSentPattern = sendUpdatedPattern(activeValues, lastSentPattern);
      } else if (activeValues.every((value) => value == 0)) //active values is all 0
      {
        updateCircleProperties(bassSquare, getBassBoolValue(bass));
        updateCircleProperties(midRangeSquare, getMidrangeBoolValue(midRange));
        updateCircleProperties(lowerMidrangeSquare, getLowerMidrangeBoolValue(lowerMidrange));
        updateCircleProperties(subBassSquare, getSubBassBoolValue(subBass));
        updateCircleProperties(presenceSquare, getPresenceBoolValue(presence));
        updateCircleProperties(higherMidrangeSquare, getUpperMidrangeBoolValue(higherMidrange));
        updateCircleProperties(brillianceSquare, getBrillianceBoolValue(brilliance));
      }

      lastSentPattern = sendUpdatedPattern(activeValues, lastSentPattern);
    });

    // Ensure a rebuild to reflect color and size changes
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIconButton(
                    icon: Icons.arrow_drop_down,
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("/MainScreen");
                    },
                  ),
                  AppButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/PlayGame');
                    },
                    child: const Text('Basic'),
                  ),
                  AppButton(
                    onPressed: () {},
                    child: const Text('Intermediate'),
                  ),
                  AppIconButton(
                    icon: Icons.more_vert,
                    onPressed: () => {},
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              ...buildRayPainterRows(),
            ],
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.songData.title,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    widget.songData.artist,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(secToMinSec(currentPositionSec)), // Display current playback position
                      const SizedBox(width: 20),
                      Expanded(
                        child: SongSlider(
                          currentDuration: currentPositionSec,
                          minDuration: 0,
                          maxDuration: widget.songData.duration,
                          onDurationChanged: (value) => _onDurationChanged(value),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(widget.songData.songTime),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppIconButton(
                        icon: Icons.shuffle,
                        onPressed: () {},
                      ),
                      AppIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () {},
                      ),
                      AppIconButton(
                          icon: isPlaying ? Icons.pause : Icons.play_arrow,
                          onPressed: () => {
                                togglePlay(widget.songData.audioSource),
                              }),
                      AppIconButton(
                        icon: Icons.arrow_forward,
                        onPressed: () {},
                      ),
                      AppIconButton(
                        icon: Icons.playlist_play,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String secToMinSec(double seconds) {
    int roundedSeconds = seconds.round();
    int minutes = roundedSeconds ~/ 60;
    int remainingSeconds = roundedSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void _onDurationChanged(double value) {
    // Seek the audio player to the new value
    audioPlayer.seek(Duration(seconds: value.toInt()));
    // Update any state related to the current playback position, if necessary
  }

  List<Widget> buildRayPainterRows() {
    List<Widget> rows = [];
    int itemsPerRow = 4; // Number of RayPainters per row
    for (int i = 0; i < circles.length; i += itemsPerRow) {
      List<Widget> rowItems = circles.sublist(i, min(i + itemsPerRow, circles.length)).map((circleState) {
        return SizedBox(
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
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: rowItems));
    }
    return rows;
  }

  void updateCircleState(int index, Color color, double width, double height, int activeValue) {
    setState(() {
      circles[index].color = color;
      circles[index].circleWidth = width;
      circles[index].circleHeight = height;

      activeValues[index] = activeValue;
    });
    lastSentPattern = sendUpdatedPattern(activeValues, lastSentPattern);
  }

  void resetAllCircles(Color color, double width, double height, int activeValue) {
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

  void updateCirclePropertiesNoteOnset(List<int> squares, bool isActive) {
    final double size = isActive ? 40.0 : 20.0;
    final int activeValue = isActive ? 1 : 0;

    for (int i = 0; i < squares.length; i++) {
      circles[squares[i]].circleWidth = size;
      circles[squares[i]].circleHeight = size;
      circles[squares[i]].color = isActive ? Colors.green : Colors.blue;
      activeValues[squares[i]] = activeValue;
    }
  }

  void updateCircleProperties(List<int> squares, bool isActive) {
    final double size = isActive ? 40.0 : 20.0;
    final int activeValue = isActive ? 1 : 0;

    for (int i = 0; i < squares.length; i++) {
      circles[squares[i]].circleWidth = size;
      circles[squares[i]].circleHeight = size;
      circles[squares[i]].color = isActive ? Colors.yellow : Colors.blue;
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
}
