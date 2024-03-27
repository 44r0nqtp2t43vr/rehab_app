import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';

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

  static final List<ImageTexture> imageTextures = [
    ImageTexture(
      name: 'bricks',
      image: 'assets/images/image_texture/images/bricks.png',
      texture: 'assets/images/image_texture/textures/bricks.png',
    ),
    ImageTexture(
      name: 'corduroy',
      image: 'assets/images/image_texture/images/corduroy.png',
      texture: 'assets/images/image_texture/textures/corduroy.png',
    ),
    ImageTexture(
      name: 'ratan',
      image: 'assets/images/image_texture/images/ratan.png',
      texture: 'assets/images/image_texture/textures/ratan.png',
    ),
    ImageTexture(
      name: 'sandpaper',
      image: 'assets/images/image_texture/images/sandpaper.png',
      texture: 'assets/images/image_texture/textures/sandpaper.png',
    ),
    ImageTexture(
      name: 'steel',
      image: 'assets/images/image_texture/images/steel.png',
      texture: 'assets/images/image_texture/textures/steel.png',
    ),
    ImageTexture(
      name: 'tiles',
      image: 'assets/images/image_texture/images/tiles.png',
      texture: 'assets/images/image_texture/textures/tiles.png',
    ),
  ];

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
