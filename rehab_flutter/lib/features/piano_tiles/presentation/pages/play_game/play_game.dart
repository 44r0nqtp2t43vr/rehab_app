import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_container.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/screens/visualizer_screen.dart';

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
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: const Text("Play again?"),
    //       actions: <Widget>[
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             _restart();
    //           },
    //           child: const Text("Restart"),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             Navigator.of(context).pop();
    //           },
    //           child: const Text("Exit"),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  // void _onSettingsButtonPressed() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Switch to Visualizer?"),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("Yes"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("No"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _onMinimize(BuildContext context) {
    sl<SongController>().setNoteIndex(currentNoteIndex);
    Navigator.of(context).pushReplacementNamed("/MainScreen");
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

    player
        .play(AssetSource(widget.song.audioSource))
        .then((value) => animationController.forward());
    animationController.forward();
    player.seek(Duration(milliseconds: currentNoteIndex * 300));
    player.play(AssetSource(widget.song.audioSource));
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
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
                        onPressed: () => _onMinimize(context),
                      ),
                      AppButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/PlayGame');
                        },
                        child: const Text('Basic'),
                      ),
                      AppButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisualizerScreenSlider(songData: widget.song),
                            ),
                          );
                        },
                        child: const Text('Intermediate'),
                      ),
                      AppIconButton(
                        icon: Icons.more_vert,
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
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        widget.song.artist,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(secToMinSec(
                              notes[currentNoteIndex].orderNumber * 0.3)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SongSlider(
                              currentDuration: currentNoteIndex * 0.3,
                              minDuration: 0,
                              maxDuration: widget.song.duration,
                              onDurationChanged: (value) =>
                                  _onDurationChanged(value),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(widget.song.songTime),
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
                            onPressed: () => isPlaying
                                ? _pauseAnimation()
                                : _resumeAnimation(),
                          ),
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
        ),
      ),
    );
  }
}
