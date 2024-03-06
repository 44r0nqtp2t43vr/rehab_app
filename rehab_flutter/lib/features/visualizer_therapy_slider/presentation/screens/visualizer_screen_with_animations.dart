import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // Use Animation<double> for animating circle dimensions
  late Animation<double> _circleHeightAnimation;
  late Animation<double> _circleWidthAnimation;
  double _totalHeight = 100.0;
  double _totalWidth = 100.0;
  double _targetCircleHeight = 25.0;
  double _targetCircleWidth = 25.0;
  double _rayHeight = -1.0;
  double _rayWidth = 70.0;
  Color _color = Colors.blue;
  bool isPlaying = false;
  late StreamSubscription? positionSubscription;
  List<dynamic> blocks = [];
  int lastUsedBlockIndex = -1;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // Initialize animations for circle dimensions
    _circleHeightAnimation = Tween<double>(
      begin: _targetCircleHeight,
      end: _targetCircleHeight,
    ).animate(_controller)
      ..addListener(() {
        setState(() {
          // This will trigger build method and use the animation value
        });
      });

    _circleWidthAnimation = Tween<double>(
      begin: _targetCircleWidth,
      end: _targetCircleWidth,
    ).animate(_controller)
      ..addListener(() {
        setState(() {
          // This will trigger build method and use the animation value
        });
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

  void loadBlocks() async {
    String data =
        await rootBundle.loadString('assets/data/forest_of_blocks.json');
    blocks = json.decode(data);
    // No need to sort if your JSON is already ordered based on the 'time' field
  }

  void updateCircleSize(double newHeight, double newWidth) {
    setState(() {
      _targetCircleHeight = newHeight;
      _targetCircleWidth = newWidth;
      // Update the tween ranges
      _circleHeightAnimation = Tween<double>(
        begin: _circleHeightAnimation.value,
        end: _targetCircleHeight,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
        ..addListener(() {
          setState(() {}); // Trigger rebuild with new animation values
        });

      _circleWidthAnimation = Tween<double>(
        begin: _circleWidthAnimation.value,
        end: _targetCircleWidth,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
        ..addListener(() {
          setState(() {}); // Trigger rebuild with new animation values
        });
      _controller
        ..reset()
        ..forward();
    });
  }

  void useClosestBlock(double positionSec) {
    if (blocks.isEmpty) return;

    for (int i = 0; i < blocks.length; i++) {
      if (i == blocks.length - 1 ||
          (blocks[i]['time'] <= positionSec &&
              blocks[i + 1]['time'] > positionSec)) {
        if (i != lastUsedBlockIndex) {
          // This block is the closest to the current position and hasn't been used yet
          print("Using block at index $i for position $positionSec seconds");
          lastUsedBlockIndex = i;
          setState(() {
            if (blocks[i]['note_onset'] == 1) {
              print(blocks[i]['note_onset']);
              if (_targetCircleHeight != 40) {
                updateCircleSize(40, 40);
              }
              if (_targetCircleHeight != 25) {
                // wait for 500ms then reset the circle size
                Future.delayed(Duration(milliseconds: 1000), () {
                  updateCircleSize(25, 25);
                });
              }
            }
            // else if (blocks[i]['sub_bass'] < 0.05) {
            //   updateCircleSize(15, 15);

            //   // Future.delayed(Duration(milliseconds: 2000), () {
            //   //   updateCircleSize(25, 25);
            //   // });
            // }
          });

          // print("Sub Bass: ${blocks[i]['midrange']}");
          break;
        }
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ray Painter Animation'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      circleHeight: _circleHeightAnimation.value,
                      circleWidth: _circleWidthAnimation.value,
                      rayHeight: _rayHeight,
                      rayWidth: _rayWidth,
                      color: _color,
                    ),
                  ),
                ),
              ),
            ),
            buildSlider("Total Height", _totalHeight, -100, 100, (newValue) {
              setState(() => _totalHeight = newValue);
            }),
            buildSlider("Total Width", _totalWidth, -100, 100, (newValue) {
              setState(() => _totalWidth = newValue);
            }),
            buildSlider("Circle Height", _circleWidthAnimation.value, -100, 100,
                (newValue) {
              updateCircleSize(newValue, _circleWidthAnimation.value);
            }),
            buildSlider("Circle Width", _circleWidthAnimation.value, -100, 100,
                (newValue) {
              updateCircleSize(_circleWidthAnimation.value, newValue);
            }),
            buildSlider("Ray Height", _rayHeight, -100, 100, (newValue) {
              setState(() => _rayHeight = newValue);
            }),
            buildSlider("Ray Width", _rayWidth, -100, 100, (newValue) {
              setState(() => _rayWidth = newValue);
            }),
            ElevatedButton(
              onPressed: togglePlay,
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            // Example of a simple color picker
            ListTile(
              title: Text("Select Color"),
              trailing: Container(
                width: 100,
                height: 20,
                color: _color,
              ),
              onTap: () =>
                  pickColor(context), // Implement your color picker here
            ),
          ],
        ),
      ),
    );
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

  void pickColor(BuildContext context) {
    // Here, implement your method to pick a color. It could open a dialog or another widget to select a color.
    // After selecting a color, setState to update the painter's color.
    // For simplicity, this is just an example. You might use a package like `flutter_colorpicker` to achieve this.
  }
}
