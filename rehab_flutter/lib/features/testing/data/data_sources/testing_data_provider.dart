import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/entities/tdt_pair.dart';

class TestingDataProvider {
  static final List<StaticPattern> staticPatterns = [
    StaticPattern(name: "All", pattern: "255255"),
    StaticPattern(name: "Outer Box", pattern: "207249"),
    StaticPattern(name: "Inner Box", pattern: "048006"),
    StaticPattern(name: "Vertical Line, First Column", pattern: "071000"),
    StaticPattern(name: "Vertical Line, Second Column", pattern: "184000"),
    StaticPattern(name: "Vertical Line, Third Column", pattern: "000071"),
    StaticPattern(name: "Vertical Line, Fourth Column", pattern: "000184"),
    StaticPattern(name: "Horizontal Line, First Row", pattern: "009009"),
    StaticPattern(name: "Horizontal Line, Second Row", pattern: "018018"),
    StaticPattern(name: "Horizontal Line, Third Row", pattern: "036036"),
    StaticPattern(name: "Horizontal Line, Fourth Row", pattern: "192192"),
  ];

  static final List<String> twoPDOptions = ["0", "1", "2"];

  static final List<StaticPattern> twoPDPatterns = [
    StaticPattern(name: "1P, Left of Pinky", pattern: "004000", fingerNum: 0),
    StaticPattern(name: "2P, Left of Pinky", pattern: "005000", fingerNum: 0),
    StaticPattern(name: "1P, Right of Pinky", pattern: "000032", fingerNum: 0),
    StaticPattern(name: "2P, Right of Pinky", pattern: "000040", fingerNum: 0),
    StaticPattern(name: "1P, Left of Ring", pattern: "004000", fingerNum: 1),
    StaticPattern(name: "2P, Left of Ring", pattern: "005000", fingerNum: 1),
    StaticPattern(name: "1P, Right of Ring", pattern: "000032", fingerNum: 1),
    StaticPattern(name: "2P, Right of Ring", pattern: "000040", fingerNum: 1),
    StaticPattern(name: "1P, Left of Middle", pattern: "004000", fingerNum: 2),
    StaticPattern(name: "2P, Left of Middle", pattern: "005000", fingerNum: 2),
    StaticPattern(name: "1P, Right of Middle", pattern: "000032", fingerNum: 2),
    StaticPattern(name: "2P, Right of Middle", pattern: "000040", fingerNum: 2),
    StaticPattern(name: "1P, Left of Pointer", pattern: "004000", fingerNum: 3),
    StaticPattern(name: "2P, Left of Pointer", pattern: "005000", fingerNum: 3),
    StaticPattern(name: "1P, Right of Pointer", pattern: "000032", fingerNum: 3),
    StaticPattern(name: "2P, Right of Pointer", pattern: "000040", fingerNum: 3),
    StaticPattern(name: "1P, Left of Thumb", pattern: "004000", fingerNum: 4),
    StaticPattern(name: "2P, Left of Thumb", pattern: "005000", fingerNum: 4),
    StaticPattern(name: "1P, Right of Thumb", pattern: "000032", fingerNum: 4),
    StaticPattern(name: "2P, Right of Thumb", pattern: "000040", fingerNum: 4),
  ];

  static final List<ImageTexture> imageTextures = [
    ImageTexture(
      name: 'Bricks',
      image: 'assets/images/image_texture/images/bricks.png',
      texture: 'assets/images/image_texture/textures/bricks.png',
    ),
    ImageTexture(
      name: 'Corduroy',
      image: 'assets/images/image_texture/images/corduroy.png',
      texture: 'assets/images/image_texture/textures/corduroy.png',
    ),
    ImageTexture(
      name: 'Ratan',
      image: 'assets/images/image_texture/images/ratan.png',
      texture: 'assets/images/image_texture/textures/ratan.png',
    ),
    ImageTexture(
      name: 'Sandpaper',
      image: 'assets/images/image_texture/images/sandpaper.png',
      texture: 'assets/images/image_texture/textures/sandpaper.png',
    ),
    ImageTexture(
      name: 'Steel',
      image: 'assets/images/image_texture/images/steel.png',
      texture: 'assets/images/image_texture/textures/steel.png',
    ),
    ImageTexture(
      name: 'Tiles',
      image: 'assets/images/image_texture/images/tiles.png',
      texture: 'assets/images/image_texture/textures/tiles.png',
    ),
  ];

  static final List<TdtPair> tdtPairs = _generatePairs();

  static List<TdtPair> _generatePairs() {
    final List<TdtPair> generatedPairs = [];
    for (int i = 0; i < imageTextures.length; i++) {
      for (int j = i + 1; j < imageTextures.length; j++) {
        generatedPairs.add(TdtPair(
          distractor: imageTextures[i],
          answer: imageTextures[j],
        ));
        generatedPairs.add(TdtPair(
          distractor: imageTextures[j],
          answer: imageTextures[i],
        ));
      }
    }
    return generatedPairs;
  }

  static final List<RhythmicPattern> rhythmicPatterns = [
    RhythmicPattern(
      name: "Cascade Square",
      pattern: [
        "<027000027000027000027000027000>",
        "<000027000027000027000027000027>",
        "<228000228000228000228000228000>",
        "<000228000228000228000228000228>",
      ],
    ),
    RhythmicPattern(
      name: "Line",
      pattern: [
        "<071000071000071000071000071000>",
        "<184000184000184000184000184000>",
        "<000071000071000071000071000071>",
        "<000184000184000184000184000184>",
      ],
    ),
    RhythmicPattern(
      name: "Blink",
      pattern: [
        "<000000000000000000000000000000>",
        "<255255255255255255255255255255>",
      ],
    ),
    RhythmicPattern(
      name: "Cascade",
      pattern: [
        "<009009009009009009009009009009>",
        "<018018018018018018018018018018>",
        "<036036036036036036036036036036>",
        "<192192192192192192192192192192>",
      ],
    ),
    RhythmicPattern(
      name: "Alternate",
      pattern: [
        "<149149149149149149149149149149>",
        "<106106106106106106106106106106>",
      ],
    ),
  ];
}
