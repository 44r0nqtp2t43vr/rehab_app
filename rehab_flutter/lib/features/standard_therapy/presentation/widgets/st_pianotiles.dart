import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';
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

class _STPianoTilesState extends State<STPianoTiles> with SingleTickerProviderStateMixin {
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

  void _onPass() async {
    List<int> lineNumbers = notes[currentNoteIndex].lines;
    if (lineNumbers.isEmpty) {
      return;
    } else {
      const String off = "000000";
      const String on = "255255";
      String data = "<${lineNumbers[0] == 0 ? off : on}${lineNumbers[1] == 0 ? off : on}${lineNumbers[2] == 0 ? off : on}${lineNumbers[3] == 0 ? off : on}${lineNumbers[4] == 0 ? off : on}>";
      await Future.delayed(const Duration(milliseconds: 10));
      sl<BluetoothBloc>().add(WriteDataEvent(data));
    }
  }

  void _onEnd() {
    player.pause();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
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
      double availableScreenWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right;
      double availableScreenHeight = screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom;

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
            notesToRender = notes.sublist(currentNoteIndex, currentNoteIndex + 4);
          });
          _onPass();
          animationController.forward(from: 0);
        }
      }
    });

    animationController.addListener(() {
      if ((animationController.value * 10).round() == 9) {
        sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
      }
    });

    player.play(AssetSource(widget.song.audioSource)).then((value) => animationController.forward());
    animationController.forward();
    player.seek(Duration(milliseconds: currentNoteIndex * 300));
    player.play(AssetSource(widget.song.audioSource));
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
    _initBuild(context);

    return Column(
      children: [
        const Spacer(),
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
                    Text(secToMinSec(notes[currentNoteIndex].orderNumber * 0.3)),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SongSlider(
                        currentDuration: currentNoteIndex * 0.3,
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
    );
  }
}
