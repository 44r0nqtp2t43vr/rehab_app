import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/tile.dart';

class Line extends StatelessWidget {
  final double tileHeight;
  final double tileWidth;
  final int lineNumber;
  final double animationValue;
  final int currentNoteIndex;
  final List<Note> currentNotes;

  const Line({super.key, required this.tileHeight, required this.tileWidth, required this.currentNotes, required this.animationValue, required this.currentNoteIndex, required this.lineNumber});

  @override
  Widget build(BuildContext context) {
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
      double offset = (2 - index + animationValue) * tileHeight;

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
