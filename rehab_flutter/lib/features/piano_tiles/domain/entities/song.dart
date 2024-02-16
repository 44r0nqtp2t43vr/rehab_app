import 'dart:math';

import 'package:rehab_flutter/features/piano_tiles/domain/entities/note.dart';

class Song {
  final String title;
  final String artist;
  final String audioSource;
  final double tempo;
  final List<int> beatFrames;

  Song({
    required this.title,
    required this.artist,
    required this.audioSource,
    required this.tempo,
    required this.beatFrames,
  });

  List<Note> get songNotes {
    List<Note> notes = [];
    int lastBeatFrame = beatFrames.last;
    int beatFrameIndex = 0;

    if (beatFrames.isEmpty) {
      return notes;
    }

    for (int index = 0; index < lastBeatFrame + 5; index++) {
      int lineNumber = -1;
      if (index < lastBeatFrame && index == beatFrames[beatFrameIndex]) {
        lineNumber = Random().nextInt(5);
        beatFrameIndex++;
      }
      notes.add(Note(index, lineNumber));
    }

    return notes;
  }
}
