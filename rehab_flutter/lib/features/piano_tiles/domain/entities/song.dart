import 'dart:math';

import 'package:rehab_flutter/features/piano_tiles/domain/entities/note.dart';

class Song {
  final String title;
  final String artist;
  final String audioSource;
  final double tempo;
  final List<int> noteFrames;
  final List<int> noteCounts;

  Song({
    required this.title,
    required this.artist,
    required this.audioSource,
    required this.tempo,
    required this.noteFrames,
    required this.noteCounts,
  });

  List<Note> get songNotes {
    final List<Note> notes = [];
    final List<int> choiceLines = [0, 1, 2, 3, 4];
    final int lastNoteFrame = noteFrames.last;
    int noteFrameIndex = 0;

    if (noteFrames.isEmpty) {
      return notes;
    }

    for (int i = 0; i < lastNoteFrame + 5; i++) {
      if (noteFrameIndex > noteFrames.length - 1 ||
          i != noteFrames[noteFrameIndex]) {
        notes.add(Note(i, []));
        continue;
      }

      List<int> currentLines = [0, 0, 0, 0, 0];
      List<int> currentChoiceLines = List.from(choiceLines);
      for (int j = noteCounts[noteFrameIndex]; j > 0; j--) {
        int randIndex = Random().nextInt(currentChoiceLines.length);
        int lineNumber = currentChoiceLines[randIndex];
        currentChoiceLines.removeAt(randIndex);
        currentLines[lineNumber] = 1;
      }

      notes.add(Note(i, currentLines));
      noteFrameIndex++;
    }

    return notes;
  }

  // List<Note> get songNotes {
  //   List<Note> notes = [];
  //   int lastBeatFrame = beatFrames.last;
  //   int beatFrameIndex = 0;

  //   if (beatFrames.isEmpty) {
  //     return notes;
  //   }

  //   for (int index = 0; index < lastBeatFrame + 5; index++) {
  //     int lineNumber = -1;
  //     if (index < lastBeatFrame && index == beatFrames[beatFrameIndex]) {
  //       lineNumber = Random().nextInt(5);
  //       beatFrameIndex++;
  //     }
  //     notes.add(Note(index, lineNumber));
  //   }

  //   return notes;
  // }
}
