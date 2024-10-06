// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/repository/firestore_repository.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/controllers/bluetooth_controller.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/controllers/helper_functions.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/audio_data.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/ray_painter_state.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/widgets/circle_painter.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/widgets/linear_visualizer.dart';

class STVisualizer extends StatefulWidget {
  final AppUser user;
  final Song song;
  final Function() submitCallback;

  const STVisualizer({
    super.key,
    required this.user,
    required this.song,
    required this.submitCallback,
  });

  @override
  State<STVisualizer> createState() => _STVisualizerState();
}

class _STVisualizerState extends State<STVisualizer> with SingleTickerProviderStateMixin {
  //  controllers
  late AudioPlayer audioPlayer;
  late AnimationController _controller;
  late StreamSubscription? positionSubscription;
  bool isLoading = true;

  // initial values
  final double _totalHeight = 100.0;
  final double _totalWidth = 100.0;
  final double _circleHeight = 20.0;
  final double _circleWidth = 20.0;
  final double _rayHeight = -8.0;
  final double _rayWidth = 60.0;
  final Color _color = const Color(0xff01FF99).withOpacity(0.3);
  bool isPlaying = false;

// list of circles
  List<dynamic> circles = [];

  // AudioData variables
  List<dynamic> blocks = [];
  int currentIndex = 0;
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

  //linear spectrum visualizer
  List<double> getFrequencies() {
    return [
      blocks[currentIndex].midrange.toDouble(),
      blocks[currentIndex].higherMidrange.toDouble(),
      blocks[currentIndex].bass.toDouble(),
      blocks[currentIndex].subBass.toDouble(),
      blocks[currentIndex].lowerMidrange.toDouble(),
    ];
  }

  final GlobalKey<LineAudioVisualizerState> visualizerKey = GlobalKey<LineAudioVisualizerState>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..addListener(() {
        setState(() {});
      });

    audioPlayer = AudioPlayer();
    isPlaying = true;

    // Start playing the audio
    fetchAndPlayAudio();

    _controller.repeat(reverse: true);

    circles = List.generate(16, (index) {
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
        circleSize: 25.0,
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
    loadBlocks(widget.song.metaDataUrl);

    // Subscribe to the onPositionChanged event
    positionSubscription = audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        currentPositionSec = position.inSeconds.toDouble();
      });

      useClosestBlock(position.inMilliseconds / 1000.0); // Convert milliseconds to seconds
      visualizerKey.currentState?.updateFrequencies(getFrequencies());
    });
  }

  Future<void> fetchAndPlayAudio() async {
    final firebaseRepository = FirebaseRepositoryImpl(FirebaseFirestore.instance, FirebaseStorage.instance);
    final audioUrl = await firebaseRepository.getAudioUrl(widget.song.audioSource);

    try {
      await audioPlayer.setSource(UrlSource(audioUrl));
      await audioPlayer.seek(const Duration(seconds: 0));
      await audioPlayer.resume();

      // Audio has successfully started playing
      _listenToPlayerCompletion();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load audio. Please try again."),
        ),
      );
    }
  }

  void _listenToPlayerCompletion() {
    // Listen to when the audio completes only if it was successfully played
    audioPlayer.onPlayerComplete.listen((_) {
      widget.submitCallback();
    });
  }

  void _pauseAnimation() {
    audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _resumeAnimation() {
    audioPlayer.resume();
    setState(() {
      isPlaying = true;
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
    return Column(
      children: [
        const Spacer(),
        isLoading
            ? Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xff223e65)),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff01FF99),
                    ),
                  ),
                ),
              )
            : Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xff223e65)),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: _totalHeight,
                            child: LineAudioVisualizer(
                              key: visualizerKey,
                              initialFrequencies: getFrequencies(),
                              totalHeight: _totalHeight,
                              color: _color,
                              barsBetweenMainFrequencies: 6,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...buildRayPainterRows(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        // Column(
        //   children: [
        //     ...buildRayPainterRows(),
        //   ],
        // ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.song.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sailec Medium',
                    fontSize: 20,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.song.artist,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sailec Light',
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        secToMinSec(currentPositionSec),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sailec Light',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SongSlider(
                          currentDuration: currentPositionSec,
                          minDuration: 0,
                          maxDuration: widget.song.duration,
                          onDurationChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.song.songTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sailec Light',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.shuffle,
                          size: 24,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.backward_end_fill,
                          size: 24,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_arrow_solid,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () => isPlaying ? _pauseAnimation() : _resumeAnimation(),
                      ),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.forward_end_fill,
                          size: 24,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.square_list_fill,
                          size: 24,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String secToMinSec(double seconds) {
    int roundedSeconds = seconds.round();
    int minutes = roundedSeconds ~/ 60;
    int remainingSeconds = roundedSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  List<Widget> buildRayPainterRows() {
    List<Widget> rows = [];
    int itemsPerRow = 4; // Number of RayPainters per row
    for (int i = 0; i < circles.length; i += itemsPerRow) {
      List<Widget> rowItems = circles.sublist(i, min(i + itemsPerRow, circles.length)).map((circleState) {
        return CustomPaint(
          painter: RayPainter(
            progress: circleState.progress,
            totalHeight: circleState.totalHeight,
            totalWidth: circleState.totalWidth,
            // circleHeight: circleState.circleHeight,
            // circleWidth: circleState.circleWidth,
            // rayHeight: circleState.rayHeight,
            // rayWidth: circleState.rayWidth,
            color: circleState.color,
          ),
        );
      }).toList();

      rows.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: rowItems),
      ));
    }
    return rows;
  }

  void updateCircleState(int index, Color color, double size /*double width, double height*/, int activeValue) {
    setState(() {
      circles[index].color = color;
      circles[index].circleWidth = size;
      circles[index].circleHeight = size;

      activeValues[index] = activeValue;
    });
    lastSentPattern = sendUpdatedPattern(activeValues, lastSentPattern);
  }

  void resetAllCircles(Color color, double size /*double width, double height*/, int activeValue) {
    setState(() {
      for (var circle in circles) {
        circle.color = color;
        circle.circleWidth = size;
        circle.circleHeight = size;
      }
      for (int i = 0; i < activeValues.length; i++) {
        activeValues[i] = activeValue;
      }
    });
  }

  void updateCirclePropertiesNoteOnset(List<int> squares, bool isActive) {
    final double size = isActive ? 30.0 : 25.0;
    final int activeValue = isActive ? 1 : 0;

    for (int i = 0; i < squares.length; i++) {
      circles[squares[i]].circleWidth = size;
      circles[squares[i]].circleHeight = size;
      circles[squares[i]].color = isActive ? const Color(0xff01FF99) : const Color(0xff128BED);
      activeValues[squares[i]] = activeValue;
    }
  }

  void updateCircleProperties(List<int> squares, bool isActive) {
    final double size = isActive ? 30.0 : 25.0;
    final int activeValue = isActive ? 1 : 0;

    for (int i = 0; i < squares.length; i++) {
      circles[squares[i]].circleWidth = size;
      circles[squares[i]].circleHeight = size;
      circles[squares[i]].color = isActive ? const Color(0xffCDE9FF) : const Color(0xff128BED);
      activeValues[squares[i]] = activeValue;
    }
  }

  void loadBlocks(String audioData) async {
    String data = await rootBundle.loadString(audioData);
    final List<dynamic> blockJson = json.decode(data);
    blocks = blockJson.map((json) => AudioData.fromJson(json)).toList();
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
              updateCircleState(index, Colors.yellow, 30, 1);
            }
          });

          delay += 200;
        }
        print(noteOnset);

        Timer(Duration(milliseconds: delay), () {
          resetAllCircles(const Color(0xff128BED), 20.0, 0);
        });
      } else if (noteOnset == 1) {
        updateCirclePropertiesNoteOnset(outerSquare, true);
        lastSentPattern = sendUpdatedPattern(activeValues, lastSentPattern);
      } else if (activeValues.every((value) => value == 0)) {
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
  }

  void updateFrequencies(List<double> newFrequencies) {
    visualizerKey.currentState?.updateFrequencies(newFrequencies);
  }
}
