import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/note.dart';
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

    // map notes to widgets
    List<Widget> tiles = currentNotes.map((note) {
      //specify note distance from top
      int index = note.orderNumber - currentNoteIndex;
      double offset = (3 - index + animation!.value) * tileHeight;

      // return Transform.translate(
      //   offset: Offset(0, offset),
      //   child: Tile(
      //     height: tileHeight,
      //     width: tileWidth,
      //     key: GlobalKey(),
      //   ),
      // );
      return Positioned(
        top: offset,
        child: Tile(
          height: tileHeight,
          width: tileWidth,
          key: GlobalKey(),
        ),
      );
    }).toList();

    return SizedBox(
      height: tileHeight * 4,
      child: Stack(
        children: tiles,
      ),
    );
  }
}
