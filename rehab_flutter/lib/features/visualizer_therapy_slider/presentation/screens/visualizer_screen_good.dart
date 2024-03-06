import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/audio_data.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/widgets/circle_painter.dart';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  double _rayHeight = -80.0;
  double _rayWidth = 60.0;
  Color _color = Colors.blue;
  bool isPlaying = false;
  late StreamSubscription? positionSubscription;
  List<dynamic> blocks = [];
  int lastUsedBlockIndex = -1;
  double prevWidth = 25;
  double prevHeight = 25;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);

    // Load blocks from forest_of_blocks.json
    loadBlocks();
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
        if (i != lastUsedBlockIndex) {
          setState(() {
            var midrange = blocks[i].midrange * 10;
            var higherMidrange = blocks[i].higherMidrange * 10;
            var bass = blocks[i].bass * 10;
            var subBass = blocks[i].subBass * 10;
            var lowerMidrange = blocks[i].lowerMidrange * 10;
            var presence = blocks[i].presence * 10;

            var noteOnset = blocks[i].noteOnset;

            // note onset vertical succession of _circleWidth and _circleHeight 40

            // Adjusting _circleWidth and _circleHeight based on midrange
            _circleWidth = interpolate(midrange, 10, 40, 25, 10);
            _circleHeight = interpolate(midrange, 10, 40, 25, 10);

            // Adjusting _rayHeight based on bass
            _rayHeight = interpolate(bass, 10, -10, -5, -1);

            // Adjusting _rayWidth based on subBass
            _rayWidth = interpolate(subBass, 10, 80, 70, 60);

            _color = getColor(higherMidrange);
          }

              // vibrate on presence

              // lowerMidrange horizontal succession
              );
          lastUsedBlockIndex = i;
          break;
        }
      }
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
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // To space out the ray painters evenly
              children: List.generate(
                4,
                (index) => // Generate 4 containers
                    Container(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: RayPainter(
                      progress: _controller.value,
                      totalHeight: _totalHeight,
                      totalWidth: _totalWidth,
                      circleHeight: _circleHeight,
                      circleWidth: _circleWidth,
                      rayHeight: _rayHeight,
                      rayWidth: _rayWidth,
                      color: _color,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // To space out the ray painters evenly
              children: List.generate(
                4,
                (index) => // Generate 4 containers
                    Container(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: RayPainter(
                      progress: _controller.value,
                      totalHeight: _totalHeight,
                      totalWidth: _totalWidth,
                      circleHeight: _circleHeight,
                      circleWidth: _circleWidth,
                      rayHeight: _rayHeight,
                      rayWidth: _rayWidth,
                      color: _color,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // To space out the ray painters evenly
              children: List.generate(
                4,
                (index) => // Generate 4 containers
                    Container(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: RayPainter(
                      progress: _controller.value,
                      totalHeight: _totalHeight,
                      totalWidth: _totalWidth,
                      circleHeight: _circleHeight,
                      circleWidth: _circleWidth,
                      rayHeight: _rayHeight,
                      rayWidth: _rayWidth,
                      color: _color,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // To space out the ray painters evenly
              children: List.generate(
                4,
                (index) => // Generate 4 containers
                    Container(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: RayPainter(
                      progress: _controller.value,
                      totalHeight: _totalHeight,
                      totalWidth: _totalWidth,
                      circleHeight: _circleHeight,
                      circleWidth: _circleWidth,
                      rayHeight: _rayHeight,
                      rayWidth: _rayWidth,
                      color: _color,
                    ),
                  ),
                ),
              ),
            ),
            // buildSlider("Total Height", _totalHeight, -100, 100, (newValue) {
            //   setState(() => _totalHeight = newValue);
            // }),
            // buildSlider("Total Width", _totalWidth, -100, 100, (newValue) {
            //   setState(() => _totalWidth = newValue);
            // }),
            // buildSlider("Circle Height", _circleHeight, -100, 100, (newValue) {
            //   setState(() => _circleHeight = newValue);
            // }),
            // buildSlider("Circle Width", _circleWidth, -100, 100, (newValue) {
            //   setState(() => _circleWidth = newValue);
            // }),
            // buildSlider("Ray Height", _rayHeight, -100, 100, (newValue) {
            //   setState(() => _rayHeight = newValue);
            // }),
            // buildSlider("Ray Width", _rayWidth, -100, 100, (newValue) {
            //   setState(() => _rayWidth = newValue);
            // }),
            ElevatedButton(
              onPressed: togglePlay,
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            // // Example of a simple color picker
            // ListTile(
            //   title: Text("Select Color"),
            //   trailing: Container(
            //     width: 100,
            //     height: 20,
            //     color: _color,
            //   ),
            //   onTap: () =>
            //       pickColor(context), // Implement your color picker here
            // ),
          ],
        ),
      ),
    );
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
