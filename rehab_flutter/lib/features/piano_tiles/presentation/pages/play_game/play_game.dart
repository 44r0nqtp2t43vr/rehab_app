import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_divider.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_slider.dart';
import 'package:rehab_flutter/injection_container.dart';

class PlayGame extends StatefulWidget {
  final Song song;

  const PlayGame({super.key, required this.song});

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  late AnimationController animationController;
  late List<Note> notes;
  int currentNoteIndex = 0;
  bool hasStarted = true;
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

  @override
  void initState() {
    super.initState();
    notes = List.from(widget.song.songNotes);
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
          });
          _onPass();
          animationController.forward(from: 0);
        }
      }
    });

    animationController.addListener(() {
      if ((animationController.value * 10).round() == 5) {
        sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
      }
    });

    player.play(AssetSource(widget.song.audioSource)).then((value) => animationController.forward());
  }

  @override
  void dispose() {
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    animationController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size including the safe area
    Size screenSize = MediaQuery.of(context).size;

    // Get the safe area insets
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;

    // Calculate the available screen size excluding the safe area
    double availableScreenWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right;
    double availableScreenHeight = screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom;

    double tileWidth = availableScreenWidth / 5;
    double tileHeight = ((availableScreenHeight / 9) * 5) / 4;

    return Scaffold(
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
                      onPressed: () {},
                    ),
                    AppButton(
                      onPressed: () {},
                      child: const Text('Basic'),
                    ),
                    AppButton(
                      onPressed: () {},
                      child: const Text('Intermediate'),
                    ),
                    AppIconButton(
                      icon: Icons.more_vert,
                      onPressed: () => _onSettingsButtonPressed(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Image.asset(
                    'assets/images/background.jpg',
                    fit: BoxFit.cover,
                  ),
                  Row(
                    children: <Widget>[
                      _drawLine(0, tileHeight, tileWidth),
                      const LineDivider(),
                      _drawLine(1, tileHeight, tileWidth),
                      const LineDivider(),
                      _drawLine(2, tileHeight, tileWidth),
                      const LineDivider(),
                      _drawLine(3, tileHeight, tileWidth),
                      const LineDivider(),
                      _drawLine(4, tileHeight, tileWidth),
                    ],
                  ),
                ],
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
                        Text(secToMinSec(notes[currentNoteIndex].orderNumber * 0.3)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SongSlider(
                            currentDuration: currentNoteIndex * .3,
                            minDuration: 0,
                            maxDuration: widget.song.duration,
                            onDurationChanged: (value) {},
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
                          onPressed: () => isPlaying ? _pauseAnimation() : _resumeAnimation(),
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
    );
  }

  void _onPass() async {
    List<int> lineNumbers = notes[currentNoteIndex].lines;
    if (lineNumbers.isEmpty) {
      return;
    } else {
      const String off = "000000";
      const String on = "255255";
      String data = "<${lineNumbers[0] == 0 ? off : on}${lineNumbers[1] == 0 ? off : on}${lineNumbers[2] == 0 ? off : on}${lineNumbers[3] == 0 ? off : on}${lineNumbers[4] == 0 ? off : on}>";
      await Future.delayed(const Duration(milliseconds: 5));
      sl<BluetoothBloc>().add(WriteDataEvent(data));
    }
  }

  void _restart() {
    setState(() {
      notes = List.from(widget.song.songNotes);
      hasStarted = true;
      isPlaying = true;
      currentNoteIndex = 0;
    });
    animationController.reset();
    player.play(AssetSource(widget.song.audioSource)).then((value) => animationController.forward());
  }

  void _onEnd() {
    player.stop();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Play again?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restart();
              },
              child: const Text("Restart"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  void _onSettingsButtonPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Switch to Visualizer?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  _drawLine(int lineNumber, double tileHeight, double tileWidth) {
    return Expanded(
      child: Line(
        tileHeight: tileHeight,
        tileWidth: tileWidth,
        lineNumber: lineNumber,
        currentNotes: notes.sublist(currentNoteIndex, currentNoteIndex + 5).where((note) => note.lines.isNotEmpty && note.lines[lineNumber] == 1).toList(),
        currentNoteIndex: currentNoteIndex,
        animation: animationController,
        key: GlobalKey(),
      ),
    );
  }
}
