import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/note.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/song.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_divider.dart';
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
          animationController.forward(from: 0);
        }
      }
    });

    animationController.addListener(() {
      if (animationController.value > 0.00 && animationController.value < 0.30 && currentNoteIndex != notes.last.orderNumber - 5) {
        _onPass(notes[currentNoteIndex].lines);
      }
    });

    animationController.addListener(() {
      if (animationController.value > 0.30 && currentNoteIndex != notes.last.orderNumber - 5) {
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
    double tileHeight = MediaQuery.of(context).size.height / 6;
    double tileWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // assume many children
              ],
            ),
          ),
          Expanded(
            flex: 4,
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
            flex: 1,
            child: Column(
              children: [
                // assume many children
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPass(List<int> lineNumbers) {
    if (lineNumbers.isEmpty) {
      return;
    } else {
      const String off = "000000";
      const String on = "255255";
      String data = "<${lineNumbers[0] == 0 ? off : on}${lineNumbers[1] == 0 ? off : on}${lineNumbers[2] == 0 ? off : on}${lineNumbers[3] == 0 ? off : on}${lineNumbers[4] == 0 ? off : on}>";
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
