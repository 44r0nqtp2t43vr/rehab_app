import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/note.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/line_divider.dart';

class LineContainer extends AnimatedWidget {
  final double tileHeight;
  final double tileWidth;
  final int currentNoteIndex;
  final List<Note> currentNotes;

  const LineContainer(
      {required Key key,
      required this.tileHeight,
      required this.tileWidth,
      required this.currentNotes,
      required this.currentNoteIndex,
      required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double>? animation = super.listenable as Animation<double>?;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff223e65),
      ),
      child: Row(
        children: <Widget>[
          _drawLine(0, tileHeight, tileWidth, animation!.value),
          const LineDivider(),
          _drawLine(1, tileHeight, tileWidth, animation.value),
          const LineDivider(),
          _drawLine(2, tileHeight, tileWidth, animation.value),
          const LineDivider(),
          _drawLine(3, tileHeight, tileWidth, animation.value),
          const LineDivider(),
          _drawLine(4, tileHeight, tileWidth, animation.value),
        ],
      ),
    );
  }

  Widget _drawLine(int lineNumber, double tileHeight, double tileWidth,
      double animationValue) {
    return Expanded(
      child: Line(
        tileHeight: tileHeight,
        tileWidth: tileWidth,
        lineNumber: lineNumber,
        currentNotes: currentNotes,
        animationValue: animationValue,
        currentNoteIndex: currentNoteIndex,
      ),
    );
  }
}
