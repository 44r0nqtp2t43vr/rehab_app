import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/visualizer_therapy/domain/audio_data.dart';
import 'package:rehab_flutter/features/visualizer_therapy/presentation/widgets/circle_row.dart';

import 'package:rehab_flutter/injection_container.dart';

class VisualizerScreen extends StatefulWidget {
  @override
  _VisualizerScreenState createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer audioPlayer;
  late bool isPlaying;
  late AnimationController _animationController; // Made non-nullable
  late List<AudioData> audioDataList; // Made non-nullable
  Timer? timer;

  late double _currentTimeInSeconds;
  late double _midRange;
  late double _rayHeight;
  late double _rayWidth;
  late double _circleWidth;
  late double _circleHeight;
  late String lastSentPattern;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    isPlaying = false;
    lastSentPattern = "";
    _rayHeight = 10;
    _rayWidth = 40;
    _circleHeight = 0;
    _circleWidth = 0;

    _midRange = 0;
    _currentTimeInSeconds = 0;

    loadAudioData().then((loadedData) {
      if (mounted) {
        setState(() {
          audioDataList = loadedData;
        });
      }
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..repeat(reverse: true);
  }

  Future<void> updateVisualizer() async {
    final currentPosition = await audioPlayer.getCurrentPosition();
    final currentTimeInSeconds = currentPosition != null
        ? currentPosition.inMilliseconds.toDouble() / 1000
        : 0.0;

    final currentData = getCurrentDataEntry(currentTimeInSeconds);
    if (currentData != null) {
      setState(() {
        _currentTimeInSeconds = currentTimeInSeconds; // Update the current time

        if (currentData.midrange != _midRange) {
          _midRange = currentData.midrange;
        }

        if (currentData.count == 1) {
          _circleHeight = 20;
          _circleWidth = 20;
          _sendUpdatedPattern(1);
          // wait 20 seconds the send 0
          Future.delayed(const Duration(milliseconds: 100), () {
            _sendUpdatedPattern(0);
          });

          print("Playback time: ${currentTimeInSeconds}");
          print("Data time: ${currentData.time}");
          print("sent");
        } else {
          _circleHeight = 10;
          _circleWidth = 10;
        }
      });
    }
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
      timer = Timer.periodic(Duration(milliseconds: 10),
          (Timer t) => updateVisualizer()); // Restart the visualizer updates
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<List<AudioData>> loadAudioData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/final.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((data) => AudioData.fromJson(data)).toList();
  }

  AudioData? getCurrentDataEntry(double currentTime) {
    // Check if the audioDataList is null or empty first to avoid unnecessary processing
    if (audioDataList == null || audioDataList!.isEmpty) {
      return null;
    }
    // Attempt to find the last data entry where the condition matches
    try {
      return audioDataList!.lastWhere((data) => data.time <= currentTime);
    } catch (e) {
      // If no entry is found, lastWhere throws an error, which we catch to return null
      return null;
    }
  }

// Actuators
  void sendPattern(int left, int right) {
    String leftString = left.toString().padLeft(3, '0');
    String rightString = right.toString().padLeft(3, '0');
    String data =
        "<$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString>";
    sl<BluetoothBloc>().add(WriteDataEvent(data));
    print("Pattern sent: $data");
  }

  void _sendUpdatedPattern(int x) {
    if (x == 1) {
      sendPattern(255, 255);
    } else {
      sendPattern(0, 0);
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alternating Rays Animation"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleRow(
                animationController: _animationController,
                circleWidth: _circleWidth,
                circleHeight: _circleHeight,
                rayHeight: _rayHeight,
                rayWidth: _rayWidth,
                midRange: _midRange),
            CircleRow(
                animationController: _animationController,
                circleWidth: _circleWidth,
                circleHeight: _circleHeight,
                rayHeight: _rayHeight,
                rayWidth: _rayWidth,
                midRange: _midRange),
            CircleRow(
                animationController: _animationController,
                circleWidth: _circleWidth,
                circleHeight: _circleHeight,
                rayHeight: _rayHeight,
                rayWidth: _rayWidth,
                midRange: _midRange),
            CircleRow(
                animationController: _animationController,
                circleWidth: _circleWidth,
                circleHeight: _circleHeight,
                rayHeight: _rayHeight,
                rayWidth: _rayWidth,
                midRange: _midRange),
            ElevatedButton(
              onPressed: togglePlay,
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
