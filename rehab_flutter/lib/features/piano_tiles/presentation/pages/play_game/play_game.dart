import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/core/repository/firestore_repository.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_container.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';

import 'package:rehab_flutter/injection_container.dart';

class PlayGame extends StatefulWidget {
  final Song song;
  final int startingNoteIndex;

  const PlayGame(
      {super.key, required this.song, required this.startingNoteIndex});

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame>
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

  void _onDurationChanged(double value) {
    value =
        value <= widget.song.duration - 1 ? value : widget.song.duration - 1;
    setState(() {
      currentNoteIndex = value ~/ 0.3;
      notesToRender = notes.sublist(currentNoteIndex, currentNoteIndex + 4);
    });
    player.seek(Duration(milliseconds: currentNoteIndex * 300));
    if (isPlaying) {
      player.resume();
      animationController.forward();
    }
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

  // void _restart() {
  //   setState(() {
  //     notes = List.from(widget.song.songNotes);
  //     hasStarted = true;
  //     isPlaying = true;
  //     currentNoteIndex = 0;
  //   });
  //   animationController.reset();
  //   player.play(AssetSource(widget.song.audioSource)).then((value) => animationController.forward());
  // }

  void _onEnd() {
    player.pause();
    sl<BluetoothBloc>()
        .add(const WriteDataEvent("<000000000000000000000000000000>"));
    setState(() {
      isPlaying = false;
    });
    animationController.reset();
  }

  void _onMinimize(BuildContext context) {
    sl<SongController>().setCurrentDuration(currentNoteIndex * 0.3);
    Navigator.of(context).pushReplacementNamed("/MainScreen");
  }

  void _onSwitch(BuildContext context) {
    sl<SongController>().setCurrentDuration(0);
    sl<SongController>().setMTType(MusicTherapy.intermediate);
    Navigator.of(context).pushReplacementNamed("/VisualizerScreen");
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
    currentNoteIndex = widget.startingNoteIndex;
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
    final firebaseRepository = FirebaseRepositoryImpl(
        FirebaseFirestore.instance, FirebaseStorage.instance);
    final audioUrl =
        await firebaseRepository.getAudioUrl(widget.song.audioSource);
    await player.play(UrlSource(audioUrl));
    animationController.forward();
    player.seek(Duration(milliseconds: currentNoteIndex * 300));
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
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
                      color: const Color(0xff3572C6).withOpacity(0.50),
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white.withOpacity(0.25),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                              elevation: MaterialStateProperty.all<double>(0),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                    icon: const Icon(
                      CupertinoIcons.ellipsis_vertical,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(
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
                            onDurationChanged: (value) =>
                                _onDurationChanged(value),
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
                          icon: const Icon(
                            CupertinoIcons.shuffle,
                            size: 24,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.backward_end_fill,
                            size: 24,
                            color: Colors.white,
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
                        // AppIconButton(
                        //   icon: isPlaying ? Icons.pause : Icons.play_arrow,
                        //   onPressed: () => isPlaying
                        //       ? _pauseAnimation()
                        //       : _resumeAnimation(),
                        // ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.forward_end_fill,
                            size: 24,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.square_list_fill,
                            size: 24,
                            color: Colors.white,
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
