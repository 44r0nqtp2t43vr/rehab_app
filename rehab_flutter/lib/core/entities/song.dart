import 'package:rehab_flutter/core/enums/genre_enum.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';

class Song {
  final String title;
  final String artist;
  final String audioSource;
  final Genre genre;
  final double tempo;
  final double duration;
  final String metaDataUrl;

  Song({
    required this.title,
    required this.artist,
    required this.audioSource,
    required this.genre,
    required this.tempo,
    required this.duration,
    this.metaDataUrl = '',
  });

  String get songTime {
    return secToMinSec(duration);
  }

  int get songLastNote {
    return duration ~/ 0.3;
  }

  // double get noteCountsPerFrame {
  //   // Calculate the sum of all numbers in the list
  //   int sum = noteCounts.reduce((value, noteCount) => value + noteCount);

  //   // Calculate the average
  //   double average = sum / noteCounts.length;

  //   return average;
  // }

  // List<Note> get songNotes {
  //   final List<Note> notes = [];
  //   final List<int> choiceLines = [0, 1, 2, 3, 4];
  //   int noteFrameIndex = 0;

  //   if (noteFrames.isEmpty) {
  //     return notes;
  //   }

  //   for (int i = 0; i < songLastNote + 5; i++) {
  //     if (noteFrameIndex > noteFrames.length - 1 || i != noteFrames[noteFrameIndex]) {
  //       notes.add(Note(i, []));
  //       continue;
  //     }

  //     List<int> currentLines = [0, 0, 0, 0, 0];
  //     List<int> currentChoiceLines = List.from(choiceLines);
  //     for (int j = noteCounts[noteFrameIndex]; j > 0; j--) {
  //       int randIndex = Random().nextInt(currentChoiceLines.length);
  //       int lineNumber = currentChoiceLines[randIndex];
  //       currentChoiceLines.removeAt(randIndex);
  //       currentLines[lineNumber] = 1;
  //     }

  //     notes.add(Note(i, currentLines));
  //     noteFrameIndex++;
  //   }

  //   return notes;
  // }
}
