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
  double _circleHeight = 25.0;
  double _circleWidth = 25.0;
  double _rayHeight = -1.0;
  double _rayWidth = 70.0;
  Color _color = Colors.blue;
  bool isPlaying = false;

  get timer => null;

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
  }

  void togglePlay() async {
    if (timer != null) {
      timer!.cancel(); // Ensure the existing timer is cancelled before toggling
    }
    if (isPlaying) {
      await audioPlayer.pause();
      timer?.cancel(); // Stop updating the visualizer when paused
    } else {
      await audioPlayer.play(AssetSource('audio/Exb_30.mp3'));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
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
            buildSlider("Total Height", _totalHeight, -100, 100, (newValue) {
              setState(() => _totalHeight = newValue);
            }),
            buildSlider("Total Width", _totalWidth, -100, 100, (newValue) {
              setState(() => _totalWidth = newValue);
            }),
            buildSlider("Circle Height", _circleHeight, -100, 100, (newValue) {
              setState(() => _circleHeight = newValue);
            }),
            buildSlider("Circle Width", _circleWidth, -100, 100, (newValue) {
              setState(() => _circleWidth = newValue);
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
