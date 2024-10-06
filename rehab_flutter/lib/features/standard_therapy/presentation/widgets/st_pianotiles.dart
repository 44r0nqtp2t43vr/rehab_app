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
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/repository/firestore_repository.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_divider.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/tile.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/audio_data.dart';
import 'package:rehab_flutter/injection_container.dart';

class STPianoTiles extends StatefulWidget {
  final AppUser user;
  final Song song;
  final Function() submitCallback;

  const STPianoTiles({
    super.key,
    required this.user,
    required this.song,
    required this.submitCallback,
  });

  @override
  State<STPianoTiles> createState() => _STPianoTilesState();
}

class _STPianoTilesState extends State<STPianoTiles> {
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

  String secToMinSec(double seconds) {
    int roundedSeconds = seconds.round();
    int minutes = roundedSeconds ~/ 60;
    int remainingSeconds = roundedSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void loadBlocks(String audioData) async {
    String data = await rootBundle.loadString(audioData);
    final List<dynamic> blockJson = json.decode(data);
    blocks = blockJson.map((json) => AudioData.fromJson(json)).toList();
    blocksToRender = blocks.sublist(currentIndex, currentIndex + 6 > blocks.length - 1 ? blocks.length - 1 : currentIndex + 6);
  }

  void _onPass(AudioData block) async {
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

      sl<BluetoothBloc>().add(WriteDataEvent(data));
      await Future.delayed(const Duration(milliseconds: 40));
      sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    } else {
      sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    }
  }

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    isPlaying = true;

    // Start playing the audio
    fetchAndPlayAudio();

    // Load blocks from the song's metadata
    loadBlocks(widget.song.metaDataUrl);

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
              blocksToRender = blocks.sublist(
                currentIndex,
                currentIndex + 6 > blocks.length - 1 ? blocks.length - 1 : currentIndex + 6,
              );
            });

            break;
          }
        }
      }
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
    audioPlayer.onPlayerComplete.listen((event) {
      widget.submitCallback();
    });
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
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
                          secToMinSec(currentIndex * 0.2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sailec Light',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SongSlider(
                            currentDuration: currentIndex * 0.2,
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
        ),
      ],
    );
  }
}
