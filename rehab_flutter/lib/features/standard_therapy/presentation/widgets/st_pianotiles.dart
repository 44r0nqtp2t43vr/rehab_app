// ignore_for_file: avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/repository/firestore_repository.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_container.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';
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

class _STPianoTilesState extends State<STPianoTiles>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  late AnimationController animationController;
  late List<Note> notes;
  late List<Note> notesToRender;
  late double tileHeight;
  late double tileWidth;
  late int currentNoteIndex;
  bool hasStarted = false;
  bool isPlaying = true;
  late String audioUrl;
  bool isLoading = true;

  void _pauseAnimation() {
    animationController.stop();
    player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _resumeAnimation() {
    animationController.forward();
    player.resume();
    setState(() {
      isPlaying = true;
    });
  }

  void _onPass() async {
    List<int> lineNumbers = notes[currentNoteIndex].lines;
    if (lineNumbers.isEmpty) {
      return;
    } else {
      const String off = "000000";
      const String on = "255255";
      String data =
          "<${lineNumbers[0] == 0 ? off : on}${lineNumbers[1] == 0 ? off : on}${lineNumbers[2] == 0 ? off : on}${lineNumbers[3] == 0 ? off : on}${lineNumbers[4] == 0 ? off : on}>";
      await Future.delayed(const Duration(milliseconds: 10));
      sl<BluetoothBloc>().add(WriteDataEvent(data));
    }
  }

  void _onEnd() {
    player.pause();
    sl<BluetoothBloc>()
        .add(const WriteDataEvent("<000000000000000000000000000000>"));
    setState(() {
      isPlaying = false;
    });
    animationController.reset();
    widget.submitCallback();
  }

  void _initBuild(BuildContext context) {
    if (!hasStarted) {
      // Get the screen size including the safe area
      Size screenSize = MediaQuery.of(context).size;

      // Get the safe area insets
      EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;

      // Calculate the available screen size excluding the safe area
      double availableScreenWidth =
          screenSize.width - safeAreaInsets.left - safeAreaInsets.right;
      double availableScreenHeight =
          screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom;

      setState(() {
        tileWidth = availableScreenWidth / 5;
        tileHeight = ((availableScreenHeight / 9) * 5) / 3;
        hasStarted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    notes = List.from(widget.song.songNotes);
    currentNoteIndex = 0;
    notesToRender = notes.sublist(currentNoteIndex, currentNoteIndex + 4);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 299725),
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (currentNoteIndex == notes.last.orderNumber - 5) {
          _onEnd();
        } else {
          setState(() {
            currentNoteIndex++;
            notesToRender =
                notes.sublist(currentNoteIndex, currentNoteIndex + 4);
          });
          _onPass();
          animationController.forward(from: 0);
        }
      }
    });

    animationController.addListener(() {
      if ((animationController.value * 10).round() == 9) {
        sl<BluetoothBloc>()
            .add(const WriteDataEvent("<000000000000000000000000000000>"));
      }
    });

    fetchAndPlayAudio();
    // player
    //     .play(AssetSource(widget.song.audioSource))
    //     .then((value) => animationController.forward());
    // animationController.forward();
    // player.seek(Duration(milliseconds: currentNoteIndex * 300));
    // player.play(AssetSource(widget.song.audioSource));
  }

  Future<void> fetchAndPlayAudio() async {
    int retries = 3;
    while (retries > 0) {
      try {
        final firebaseRepository = FirebaseRepositoryImpl(
            FirebaseFirestore.instance, FirebaseStorage.instance);
        final audioUrl =
            await firebaseRepository.getAudioUrl(widget.song.audioSource);
        await player.play(UrlSource(audioUrl));
        animationController.forward();
        player.seek(Duration(milliseconds: currentNoteIndex * 300));

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
    sl<BluetoothBloc>()
        .add(const WriteDataEvent("<000000000000000000000000000000>"));
    animationController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initBuild(context);

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
                child: LineContainer(
                  tileHeight: tileHeight,
                  tileWidth: tileWidth,
                  currentNotes: notesToRender,
                  currentNoteIndex: currentNoteIndex,
                  animation: animationController,
                  key: GlobalKey(),
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
                          secToMinSec(
                              notes[currentNoteIndex].orderNumber * 0.3),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sailec Light',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SongSlider(
                            currentDuration: currentNoteIndex * 0.3,
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
                            isPlaying
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_arrow_solid,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () => isPlaying
                              ? _pauseAnimation()
                              : _resumeAnimation(),
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
