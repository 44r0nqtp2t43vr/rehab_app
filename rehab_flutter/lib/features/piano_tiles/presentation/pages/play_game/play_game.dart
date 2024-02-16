import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
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

class _PlayGameState extends State<PlayGame>
    with SingleTickerProviderStateMixin {
  final BluetoothController bluetoothController = BluetoothController();
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
        // if (notes[currentNoteIndex].state != NoteState.tapped) {
        //   //game over
        //   setState(() {
        //     isPlaying = false;
        //     notes[currentNoteIndex].state = NoteState.missed;
        //   });
        //   animationController.reverse().then((_) => _showFinishDialog());
        // } else if (currentNoteIndex == notes.length - 5) {
        //   //song finished
        //   _showFinishDialog();
        // } else {
        //   setState(() => ++currentNoteIndex);
        //   animationController.forward(from: 0);
        // }

        if (currentNoteIndex == notes.last.orderNumber - 5) {
          _onEnd();
        } else {
          setState(() {
            currentNoteIndex++;
            // debugPrint(notes[currentNoteIndex].orderNumber.toString());
          });
          animationController.forward(from: 0);
        }
      }
    });
    animationController.addListener(() {
      if (animationController.value > 0.50 &&
          currentNoteIndex != notes.last.orderNumber - 5) {
        _onPass(notes[currentNoteIndex].line);
      }
    });
    player
        .play(AssetSource(widget.song.audioSource))
        .then((value) => animationController.forward());
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
    double tileHeight = MediaQuery.of(context).size.height / 4;
    double tileWidth = MediaQuery.of(context).size.width / 5;

    return Material(
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
    );
  }

  void _onPass(int lineNumber) {
    if (lineNumber == -1) {
      return;
    } else {
      String data = "<000000000000000000000000000000>";
      switch (lineNumber) {
        case 0:
          data = "<255255000000000000000000000000>";
        case 1:
          data = "<000000255255000000000000000000>";
        case 2:
          data = "<000000000000255255000000000000>";
        case 3:
          data = "<000000000000000000255255000000>";
        case 4:
          data = "<000000000000000000000000255255>";
        default:
          data = "<000000000000000000000000000000>";
      }
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
    player
        .play(AssetSource(widget.song.audioSource))
        .then((value) => animationController.forward());
  }

  void _onEnd() {
    player.stop();
    sl<BluetoothBloc>()
        .add(const WriteDataEvent("<000000000000000000000000000000>"));
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
    // for instances where having multiple notes per time unit is possible
    int lastRenderIndex = notes.indexOf(
      notes.lastWhere(
        (note) => note.orderNumber == currentNoteIndex + 5,
        orElse: () => notes.last,
      ),
    );

    return Expanded(
      child: Line(
        tileHeight: tileHeight,
        tileWidth: tileWidth,
        lineNumber: lineNumber,
        currentNotes: notes
            .sublist(currentNoteIndex, lastRenderIndex)
            .where((note) => note.line == lineNumber)
            .toList(),
        currentNoteIndex: currentNoteIndex,
        animation: animationController,
        key: GlobalKey(),
      ),
    );
  }
}
