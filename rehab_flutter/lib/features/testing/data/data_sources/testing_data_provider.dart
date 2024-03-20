import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';

class TestingDataProvider {
  static final List<StaticPattern> staticPatterns = [
    StaticPattern(name: "all", pattern: "255255"),
    StaticPattern(name: "firstColVertLine", pattern: "071000"),
    StaticPattern(name: "secondColVertLine", pattern: "184000"),
    StaticPattern(name: "thirdColVertLine", pattern: "000071"),
    StaticPattern(name: "fourthColVertLine", pattern: "000184"),
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
