// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/core/repository/firestore_repository.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_divider.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/tile.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/audio_data.dart';

import 'package:rehab_flutter/injection_container.dart';

class PlayGame extends StatefulWidget {
  final Song songData;
  final double currentPositionSec;

  const PlayGame({super.key, required this.songData, this.currentPositionSec = 0.0});

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  //  controllers
  late AudioPlayer audioPlayer;
  late StreamSubscription? positionSubscription;
  bool isLoading = true;
  bool isPlaying = false;

  // AudioData variables
  List<AudioData> blocks = [];
  List<AudioData> blocksToRender = [];
  int currentIndex = 0;

  // actuator vars
  double currentPositionSec = 0.0;
  double currentPositionMil = 0.0;

  String lastSentPattern = '';

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

  void _onDurationChanged(double value) {
    setState(() {
      currentPositionSec = value;
    });
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  String secToMinSec(double seconds) {
    int roundedSeconds = seconds.round();
    int minutes = roundedSeconds ~/ 60;
    int remainingSeconds = roundedSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void _onMinimize(BuildContext context) {
    sl<SongController>().setCurrentDuration(currentPositionSec);
    Navigator.of(context).pushReplacementNamed("/MainScreen");
  }

  void _onSwitch(BuildContext context) {
    sl<SongController>().setCurrentDuration(0);
    sl<SongController>().setMTType(MusicTherapy.intermediate);
    Navigator.of(context).pushReplacementNamed("/VisualizerScreen");
  }

  void loadBlocks(String audioData) async {
    String data = await rootBundle.loadString(audioData);
    final List<dynamic> blockJson = json.decode(data);
    blocks = blockJson.map((json) => AudioData.fromJson(json)).toList();
    blocksToRender = blocks.sublist(currentIndex, currentIndex + 6 > blocks.length - 1 ? blocks.length - 1 : currentIndex + 6);
  }

  void _onPass(AudioData block) async {
    print(block.lineNumber);
    if (block.noteOnset == 1) {
      String data = "";
      switch (block.lineNumber) {
        case 0:
          data = "<255255000000000000000000000000>";
          break;
        case 1:
          data = "<000000255255000000000000000000>";
          break;
        case 2:
          data = "<000000000000255255000000000000>";
          break;
        case 3:
          data = "<000000000000000000255255000000>";
          break;
        case 4:
          data = "<000000000000000000000000255255>";
          break;
        default:
          data = "<000000000000000000000000000000>";
      }

      if (lastSentPattern == data) {
        sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
        await Future.delayed(const Duration(milliseconds: 20));
        sl<BluetoothBloc>().add(WriteDataEvent(data));
        setState(() {
          lastSentPattern = data;
        });
      } else {
        sl<BluetoothBloc>().add(WriteDataEvent(data));
        setState(() {
          lastSentPattern = data;
        });
      }
    } else {
      if (lastSentPattern != "<000000000000000000000000000000>") {
        sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    isPlaying = true;

    fetchAndPlayAudio();

    loadBlocks(widget.songData.metaDataUrl);

    positionSubscription = audioPlayer.onPositionChanged.listen((position) {
      final positionSec = (position.inMilliseconds / 1000.0);

      for (int i = 0; i < blocks.length; i++) {
        if (i == blocks.length - 1 || (blocks[i].time <= positionSec && blocks[i + 1].time > positionSec)) {
          if (i != currentIndex) {
            _onPass(blocks[currentIndex]);

            setState(() {
              currentIndex = i;
              currentPositionSec = position.inSeconds.toDouble();
              currentPositionMil = position.inMilliseconds.toDouble();
              blocksToRender = blocks.sublist(currentIndex, currentIndex + 6 > blocks.length - 1 ? blocks.length - 1 : currentIndex + 6);
            });

            break;
          }
        }
      }
    });
  }

  Future<void> fetchAndPlayAudio() async {
    int retries = 3;

    while (retries > 0) {
      try {
        final firebaseRepository = FirebaseRepositoryImpl(FirebaseFirestore.instance, FirebaseStorage.instance);
        final audioUrl = await firebaseRepository.getAudioUrl(widget.songData.audioSource);

        audioPlayer.setSource(UrlSource(widget.songData.audioSource)).then((_) {
          audioPlayer.seek(Duration(seconds: widget.currentPositionSec.toInt()));
          audioPlayer.resume();
        });

        await audioPlayer.play(UrlSource(audioUrl), position: Duration(seconds: widget.currentPositionSec.toInt()));

        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        return;
      } catch (e) {
        print('Error: $e');
        retries--;
        if (retries == 0) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to load audio. Please try again."),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    positionSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        sl<SongController>().setSong(null);
        Navigator.of(context).pushReplacementNamed("/MainScreen");
      },
      child: Scaffold(
        backgroundColor: const Color(0xff275492),
        body: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () => _onMinimize(context),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff3572C6).withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: null,
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.white,
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.white.withValues(alpha: 0.25),
                              ),
                              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                            child: const Text(
                              'Basic',
                              style: TextStyle(
                                fontFamily: 'Sailec Medium',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _onSwitch(context),
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.white,
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                              elevation: WidgetStateProperty.all<double>(0),
                              // shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                              overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                            child: const Text(
                              'Intermediate',
                              style: TextStyle(
                                fontFamily: 'Sailec Light',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.ellipsis_vertical,
                      size: 24,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
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
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Retrieve available height and width
                      final double availableHeight = constraints.maxHeight;
                      final double availableWidth = constraints.maxWidth;

                      // Use these values to calculate note size and positions
                      final double noteWidth = availableWidth / 5; // Adjust note width
                      final double noteHeight = availableHeight / 4; // Adjust note height

                      return Stack(
                        children: [
                          Container(
                            color: const Color(0xff223e65),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) => const LineDivider()),
                          ),
                          ...blocksToRender.indexed.map(((int, AudioData) note) {
                            final (index, value) = note;

                            return Positioned(
                              top: (3 - index + ((currentPositionMil % 200) / 200)) * noteHeight,
                              left: value.lineNumber! * noteWidth,
                              child: value.noteOnset == 0
                                  ? const SizedBox()
                                  : Tile(
                                      height: noteHeight,
                                      width: noteWidth,
                                    ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.songData.title,
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
                    widget.songData.artist,
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
                            maxDuration: widget.songData.duration,
                            onDurationChanged: (value) => _onDurationChanged(value),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.songData.songTime,
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
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.backward_end_fill,
                            size: 24,
                            color: Colors.white.withValues(alpha: 0.5),
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
                        // AppIconButton(
                        //   icon: isPlaying ? Icons.pause : Icons.play_arrow,
                        //   onPressed: () => isPlaying
                        //       ? _pauseAnimation()
                        //       : _resumeAnimation(),
                        // ),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.forward_end_fill,
                            size: 24,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.square_list_fill,
                            size: 24,
                            color: Colors.white.withValues(alpha: 0.5),
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
      ),
    );
  }
}
