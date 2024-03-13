import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/tile.dart';

class Line extends AnimatedWidget {
  final double tileHeight;
  final double tileWidth;
  final int lineNumber;
  final int currentNoteIndex;
  final List<Note> currentNotes;

  const Line({required Key key, required this.tileHeight, required this.tileWidth, required this.currentNotes, required this.currentNoteIndex, required this.lineNumber, required Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double>? animation = super.listenable as Animation<double>?;

    // List<Widget> tiles = [];
    // for (var i = 0; i < currentNotes.length; i++) {
    //   Note currentNote = currentNotes[i];

    //   if (currentNote.lines.isEmpty || currentNote.lines[lineNumber] != 1) {
    //     continue;
    //   }

    //   int index = currentNote.orderNumber - currentNoteIndex;
    //   double offset = (2 - index + animation!.value) * tileHeight;

    //   tiles.add(Positioned(
    //     top: offset,
    //     child: Tile(
    //       height: tileHeight,
    //       width: tileWidth,
    //     ),
    //   ));
    // }

    // map notes to widgets
    List<Widget> tiles = currentNotes.where((note) => note.lines.isNotEmpty && note.lines[lineNumber] == 1).map((note) {
      //specify note distance from top
      int index = note.orderNumber - currentNoteIndex;
      double offset = (2 - index + animation!.value) * tileHeight;

      // return Transform.translate(
      //   offset: Offset(0, offset),
      //   child: Tile(
      //     height: tileHeight,
      //     width: tileWidth,
      //   ),
      // );
      return Positioned(
        top: offset,
        child: Tile(
          height: tileHeight,
          width: tileWidth,
        ),
      );
    }).toList();

    return SizedBox(
      height: tileHeight * 3,
      child: Stack(
        children: tiles,
      ),
    );
  }
}
