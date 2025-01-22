import 'dart:math';

import 'package:rehab_flutter/core/entities/image_texture.dart';

class TdtPair {
  final ImageTexture distractor;
  final ImageTexture answer;

  TdtPair({
    required this.distractor,
    required this.answer,
  });

  List<ImageTexture> getRandomizedList() {
    // Create a list with two distractors and one answer
    List<ImageTexture> items = [
      distractor,
      distractor,
      answer,
    ];

    // Shuffle the list
    items.shuffle(Random());

    return items;
  }
}
