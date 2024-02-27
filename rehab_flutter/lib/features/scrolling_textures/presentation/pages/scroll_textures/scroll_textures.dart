import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/song.dart';
import 'package:rehab_flutter/core/widgets/animation_button.dart';
import 'package:rehab_flutter/features/scrolling_textures/domain/enums/animation_state.dart';
import 'package:rehab_flutter/features/scrolling_textures/presentation/widgets/gallery.dart';
import 'package:rehab_flutter/features/texture_therapy/data/image_texture_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_frame/widget/actuator_grid.dart';
import 'package:rehab_flutter/injection_container.dart';

class ScrollTextures extends StatefulWidget {
  final Song song;

  const ScrollTextures({super.key, required this.song});

  @override
  State<ScrollTextures> createState() => _ScrollTexturesState();
}

class _ScrollTexturesState extends State<ScrollTextures> with TickerProviderStateMixin {
  // final List<int> cursorValues = [64, 4, 2, 1, 128, 32, 16, 8, 64, 4, 2, 1, 128, 32, 16, 8];
  final AudioPlayer player = AudioPlayer();
  late List<ImageTexture> imageTextures;
  late AnimationController animationController;
  late AnimationController animationControllerHoriz;
  late img.Image photo0 = img.Image(height: 0, width: 0);
  late img.Image photo;
  late img.Image photo2;
  int currentImgIndex = 0;
  int rotateFactor = 0;
  bool hasStarted = true;
  bool isPlaying = true;
  bool isPreloaded = false;
  bool isEnded = false;
  bool isActuatorsHorizontal = true;
  bool isLastVertStateDownward = true;
  List<Offset> tapPositions0 = [];
  List<Offset> tapPositions1 = [];
  List<Offset> tapPositions2 = [];
  List<Offset> tapPositions3 = [];
  List<Offset> tapPositions4 = [];
  List<Color> tappedColors0 = [];
  List<Color> tappedColors1 = [];
  List<Color> tappedColors2 = [];
  List<Color> tappedColors3 = [];
  List<Color> tappedColors4 = [];
  String lastSentPattern = "";
  AnimationState animationState = AnimationState.downward;
  List<int> cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];

  void _pauseAnimation() {
    if (isActuatorsHorizontal) {
      animationController.stop();
    } else {
      animationControllerHoriz.stop();
    }
    setState(() {
      isPlaying = false;
    });
  }

  void _resumeAnimation() {
    if (animationState == AnimationState.downward) {
      animationController.forward();
    } else if (animationState == AnimationState.upward) {
      animationController.reverse();
    } else if (animationState == AnimationState.sideward) {
      if (animationControllerHoriz.status == AnimationStatus.forward) {
        animationControllerHoriz.forward();
      } else {
        animationControllerHoriz.reverse();
      }
    }
    setState(() {
      isPlaying = true;
    });
  }

  void _setDirectionVert() {
    animationControllerHoriz.stop();
    if (isLastVertStateDownward) {
      animationController.removeStatusListener(downwardAnimationStatusListener);
      animationController.addStatusListener(upwardAnimationStatusListener);
    } else {
      animationController.removeStatusListener(upwardAnimationStatusListener);
      animationController.addStatusListener(downwardAnimationStatusListener);
    }
    setState(() {
      isActuatorsHorizontal = true;
      cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
      if (isLastVertStateDownward) {
        animationState = AnimationState.upward;
        isLastVertStateDownward = false;
        currentImgIndex = currentImgIndex + 2;
        isEnded = false;
      } else {
        animationState = AnimationState.downward;
        isLastVertStateDownward = true;
        currentImgIndex = currentImgIndex - 2;
        isEnded = false;
      }
    });
    _loadImage(preload: true);
    _resumeAnimation();
  }

  void _switchDirectionVert() {
    _pauseAnimation();

    if (animationState == AnimationState.downward) {
      print('going upward');
      setState(() {
        animationState = AnimationState.upward;
        currentImgIndex = currentImgIndex + 2;
        isEnded = false;
        isLastVertStateDownward = false;
      });
      animationController.removeStatusListener(downwardAnimationStatusListener);
      animationController.addStatusListener(upwardAnimationStatusListener);
    } else if (animationState == AnimationState.upward) {
      print('going downward');
      setState(() {
        animationState = AnimationState.downward;
        currentImgIndex = currentImgIndex - 2;
        isEnded = false;
        isLastVertStateDownward = true;
      });
      animationController.removeStatusListener(upwardAnimationStatusListener);
      animationController.addStatusListener(downwardAnimationStatusListener);
    } else if (animationState == AnimationState.sideward) {
      animationControllerHoriz.stop();
      setState(() {
        isActuatorsHorizontal = true;
        animationState = isLastVertStateDownward ? AnimationState.downward : AnimationState.upward;
        isLastVertStateDownward = isLastVertStateDownward ? true : false;
        cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
      });
    }
    // _loadImage();
    _loadImage(preload: true);
    _resumeAnimation();
  }

  void _switchDirectionHoriz() {
    print(currentImgIndex);
    setState(() {
      // Update cursor values if necessary
      if (isActuatorsHorizontal) {
        isActuatorsHorizontal = false;
        cursorValues = [64, 4, 2, 1, 128, 32, 16, 8, 64, 4, 2, 1, 128, 32, 16, 8];
      }
      // if (isLastVertStateDownward) {
      //   currentImgIndex = isLastVertStateDownward ? currentImgIndex - 2 : currentImgIndex + 2;
      // }

      // if (isEnded) {
      //   currentImgIndex = !isLastVertStateDownward ? 0 : ImageTextureProvider().imageTextures.length - 1;
      // }
      // Set the new animation state
      animationState = AnimationState.sideward;
      animationControllerHoriz.value = 0.0;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.stop();
      animationControllerHoriz.forward(from: 0);
    });
  }

  void _incrementRotateFactor() {
    setState(() {
      rotateFactor = rotateFactor < 3 ? rotateFactor + 1 : 0;
    });
    _loadImage();
    _loadImage(preload: true);
  }

  void downwardAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && isPlaying) {
      if (currentImgIndex == imageTextures.length - 3) {
        setState(() {
          isEnded = true;
        });
      } else {
        setState(() {
          currentImgIndex++;
          photo = photo2;
          photo2 = img.Image(height: 0, width: 0);
          isPreloaded = false;
        });
        _loadImage(preload: true);
        animationController.forward(from: 0);
      }
    }
  }

  void upwardAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && isPlaying) {
      if (currentImgIndex == 2) {
        setState(() {
          isEnded = true;
        });
      } else {
        setState(() {
          currentImgIndex--;
          if (currentImgIndex - 1 > 0) {
            photo0 = photo;
            photo = photo2;
            isPreloaded = false;
          }
        });
        _loadImage(preload: true);
        animationController.reverse(from: 1);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    imageTextures = List.from([
      ...ImageTextureProvider().imageTextures,
      ...[ImageTexture(name: "", image: "", texture: ""), ImageTexture(name: "", image: "", texture: "")]
    ]);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animationControllerHoriz = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    if (animationState == AnimationState.downward) {
      animationController.addStatusListener(downwardAnimationStatusListener);
    } else if (animationState == AnimationState.upward) {
      currentImgIndex = ImageTextureProvider().imageTextures.length + 1;
      animationController.addStatusListener(upwardAnimationStatusListener);
    }

    animationControllerHoriz.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reverse the animation when it completes
        animationControllerHoriz.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Forward the animation when it is dismissed
        animationControllerHoriz.forward();
      }
    });

    player.onPlayerComplete.listen((event) {
      // When the song finishes playing, seek to the beginning and play it again
      player.seek(Duration.zero);
      player.play(AssetSource(widget.song.audioSource));
    });

    _loadImage().then((value) {
      animationController.addListener(() {
        _onPass(context);
      });

      animationControllerHoriz.addListener(() {
        _onPass(context);
      });

      _loadImage(preload: true);

      player.play(AssetSource(widget.song.audioSource)).then((value) {
        if (animationState == AnimationState.downward) {
          animationController.forward();
        } else if (animationState == AnimationState.upward) {
          animationController.reverse(from: 1);
        }
      });
    });
  }

  @override
  void dispose() {
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    animationController.dispose();
    animationControllerHoriz.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> _loadImage({bool preload = false}) async {
    try {
      int desiredWidth = 300;
      int desiredHeight = 300;
      int indexToLoad = preload
          ? animationState == AnimationState.downward
              ? currentImgIndex + 1
              : currentImgIndex - 3
          : animationState == AnimationState.downward
              ? currentImgIndex
              : currentImgIndex - 2;

      ByteData data = await rootBundle.load(imageTextures[indexToLoad].texture).then((value) {
        // Define your desired width and height for resizing
        desiredWidth = MediaQuery.of(context).size.width.toInt();
        desiredHeight = MediaQuery.of(context).size.height ~/ 2;
        return value;
      });
      Uint8List bytes = data.buffer.asUint8List();
      img.Image image = img.decodeImage(bytes)!;

      // Rotate the image
      if (rotateFactor > 0) {
        image = img.copyRotate(image, angle: 90 * rotateFactor);
      }

      // Resize the image
      image = img.copyResize(image, width: desiredWidth, height: desiredHeight, maintainAspect: false);

      setState(() {
        if (preload) {
          photo2 = image;
          isPreloaded = true;
        } else {
          photo = image;
        }
      });
    } catch (e) {
      print("Failed to load image: $e");
      // Handle error or set a default image/photo state
    }
  }

  @override
  Widget build(BuildContext context) {
    double imgHeight = MediaQuery.of(context).size.height / 2;
    double imgWidth = MediaQuery.of(context).size.width;

    return Material(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Row(
            children: <Widget>[
              _drawGallery(imgHeight, imgWidth),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: AnimationButton(
              onPressed: () => isEnded
                  ? _restart()
                  : isPlaying
                      ? _pauseAnimation()
                      : _resumeAnimation(),
              icon: Icon(isEnded
                  ? Icons.restart_alt
                  : isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
            ),
          ),
          Positioned(
            top: 80,
            right: 20,
            child: AnimationButton(
              onPressed: () => animationState == AnimationState.sideward && isEnded ? _setDirectionVert() : _switchDirectionVert(),
              icon: const Icon(Icons.swap_vert),
            ),
          ),
          Positioned(
            top: 140,
            right: 20,
            child: AnimationButton(
              onPressed: () => _switchDirectionHoriz(),
              icon: const Icon(Icons.swap_horiz),
            ),
          ),
          Positioned(
            top: 200,
            right: 20,
            child: AnimationButton(
              onPressed: () => _incrementRotateFactor(),
              icon: const Icon(Icons.rotate_90_degrees_cw),
            ),
          ),
          ...[
            ...ActuatorGrid.buildActuators(tapPositions0, tappedColors0, cursorValues),
            ...ActuatorGrid.buildActuators(tapPositions1, tappedColors1, cursorValues),
            ...ActuatorGrid.buildActuators(tapPositions2, tappedColors2, cursorValues),
            ...ActuatorGrid.buildActuators(tapPositions3, tappedColors3, cursorValues),
            ...ActuatorGrid.buildActuators(tapPositions4, tappedColors4, cursorValues),
          ],
        ],
      ),
    );
  }

  void _restart() {
    animationControllerHoriz.stop();
    setState(() {
      if (isLastVertStateDownward) {
        currentImgIndex = 0;
      } else {
        currentImgIndex = ImageTextureProvider().imageTextures.length + 1;
      }
      imageTextures = List.from([
        ...ImageTextureProvider().imageTextures,
        ...[ImageTexture(name: "", image: "", texture: ""), ImageTexture(name: "", image: "", texture: "")]
      ]);
      hasStarted = true;
      isPlaying = true;
      isEnded = false;
      tapPositions0 = [];
      tapPositions1 = [];
      tapPositions2 = [];
      tapPositions3 = [];
      tapPositions4 = [];
      tappedColors0 = [];
      tappedColors1 = [];
      tappedColors2 = [];
      tappedColors3 = [];
      tappedColors4 = [];
      lastSentPattern = "";
      photo0 = img.Image(height: 0, width: 0);
      photo2 = img.Image(height: 0, width: 0);
      isActuatorsHorizontal = true;
      animationState = isLastVertStateDownward ? AnimationState.downward : AnimationState.upward;
      isLastVertStateDownward = isLastVertStateDownward ? true : false;
      cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
    });
    animationController.reset();
    _loadImage().then((value) {
      _loadImage(preload: true);
      player.play(AssetSource(widget.song.audioSource)).then((value) {
        if (animationState != AnimationState.upward) {
          animationController.forward();
        } else if (animationState != AnimationState.downward) {
          animationController.reverse(from: 1);
        }
      });
    });
  }

  _drawGallery(double imgHeight, double imgWidth) {
    List<ImageTexture> currentImageTextures = [];
    if (animationState == AnimationState.downward) {
      currentImageTextures = imageTextures.sublist(currentImgIndex, currentImgIndex + 3);
    } else if (animationState == AnimationState.upward) {
      currentImageTextures = imageTextures.sublist(currentImgIndex - 2, currentImgIndex + 1);
    } else if (animationState == AnimationState.sideward) {
      if (isLastVertStateDownward) {
        currentImageTextures = imageTextures.sublist(currentImgIndex, currentImgIndex + 3);
      } else {
        currentImageTextures = imageTextures.sublist(currentImgIndex - 2, currentImgIndex + 1);
      }
    }

    return Expanded(
      child: Gallery(
        imgHeight: imgHeight,
        imgWidth: imgWidth,
        imageTextures: currentImageTextures,
        currentImgIndex: currentImgIndex,
        rotateFactor: rotateFactor,
        isActuatorsHorizontal: isActuatorsHorizontal,
        animation: animationController,
        key: GlobalKey(),
      ),
    );
  }

  void _onPass(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final int photoSize = screenHeight ~/ 2;
    const int spacing = 15; // Adjust the spacing value as needed

    tapPositions0.clear();
    tapPositions1.clear();
    tapPositions2.clear();
    tapPositions3.clear();
    tapPositions4.clear();
    tappedColors0.clear();
    tappedColors1.clear();
    tappedColors2.clear();
    tappedColors3.clear();
    tappedColors4.clear();

    if (isActuatorsHorizontal) {
      final double adjustedX = MediaQuery.of(context).size.width ~/ 2 * 1.00;
      final double adjustedY = screenHeight - 40; // Bottom of the screen

      for (int i = -1; i <= 2; i++) {
        for (int j = -1; j <= 2; j++) {
          final double gridX0 = adjustedX - 120 + (j * spacing);
          final double gridX1 = adjustedX - 60 + (j * spacing);
          final double gridX2 = adjustedX + (j * spacing);
          final double gridX3 = adjustedX + 60 + (j * spacing);
          final double gridX4 = adjustedX + 120 + (j * spacing);
          final double gridY = adjustedY + (i * spacing);

          final double gridYtoImage = (photo.height - 1 - 40 + (i * spacing)) - ((photo.height - 1) * animationController.value);

          final int imageX0 = max(0, min(photo.width - 1, gridX0.round()));
          final int imageX1 = max(0, min(photo.width - 1, gridX1.round()));
          final int imageX2 = max(0, min(photo.width - 1, gridX2.round()));
          final int imageX3 = max(0, min(photo.width - 1, gridX3.round()));
          final int imageX4 = max(0, min(photo.width - 1, gridX4.round()));

          // if (i == 2 && j == 2) {
          //   print("${animationController.value}, ($gridX2, $gridY), ($imageX2, $gridYtoImage), ${gridYtoImage >= 0}");
          // }

          img.Image currentPhoto = photo;
          if (gridYtoImage < 0 && animationState == AnimationState.downward) {
            currentPhoto = photo2;
          } else if (gridYtoImage < 0 && animationState == AnimationState.upward) {
            currentPhoto = photo0;
          }

          img.Pixel pixel = currentPhoto.getPixelSafe(imageX0, gridYtoImage >= 0 ? gridYtoImage.toInt() : photoSize + gridYtoImage.toInt());
          bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors0.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX1, gridYtoImage >= 0 ? gridYtoImage.toInt() : photoSize + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors1.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX2, gridYtoImage >= 0 ? gridYtoImage.toInt() : photoSize + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors2.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX3, gridYtoImage >= 0 ? gridYtoImage.toInt() : photoSize + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors3.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX4, gridYtoImage >= 0 ? gridYtoImage.toInt() : photoSize + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors4.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          // Adjust position back to display space
          tapPositions0.add(Offset(gridX0, gridY));
          tapPositions1.add(Offset(gridX1, gridY));
          tapPositions2.add(Offset(gridX2, gridY));
          tapPositions3.add(Offset(gridX3, gridY));
          tapPositions4.add(Offset(gridX4, gridY));
        }
      }
    } else {
      const double adjustedX = 40;
      final double adjustedY = screenHeight / 4 * 3;

      for (int i = -1; i <= 2; i++) {
        for (int j = -1; j <= 2; j++) {
          final double gridX = adjustedX + (j * spacing) + ((photo.width - 80) * animationControllerHoriz.value);
          final double gridY0 = adjustedY - 120 + (i * spacing);
          final double gridY1 = adjustedY - 60 + (i * spacing);
          final double gridY2 = adjustedY + (i * spacing);
          final double gridY3 = adjustedY + 60 + (i * spacing);
          final double gridY4 = adjustedY + 120 + (i * spacing);

          // final double gridYtoImage = (photo.height - 1 - 40 + (i * spacing)) - ((photo.height - 1) * animationController.value);
          final double gridY0toImage = gridY0 - photo.height - ((photo.height - 1) * animationController.value);
          final double gridY1toImage = gridY1 - photo.height - ((photo.height - 1) * animationController.value);
          final double gridY2toImage = gridY2 - photo.height - ((photo.height - 1) * animationController.value);
          final double gridY3toImage = gridY3 - photo.height - ((photo.height - 1) * animationController.value);
          final double gridY4toImage = gridY4 - photo.height - ((photo.height - 1) * animationController.value);

          final int imageX = max(0, min(photo.width - 1, gridX.round()));

          // if (i == -1 && j == -1) {
          //   // print("${animationController.value}, ($gridX, $gridY0), ($imageX, $gridY0toImage), ${gridY0toImage >= 0}");
          //   print("($gridY0, $gridY0toImage), ($gridY1, $gridY1toImage), ($gridY2, $gridY2toImage), ($gridY3, $gridY3toImage), ($gridY4, $gridY4toImage)");
          // }

          img.Pixel pixel;
          bool isWhite;
          img.Image currentPhoto = photo;

          if (gridY0toImage < 0 && animationState != AnimationState.upward) {
            currentPhoto = photo2;
          } else if (gridY0toImage < 0 && animationState != AnimationState.downward) {
            currentPhoto = photo0;
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY0toImage >= 0 ? gridY0toImage.toInt() : photoSize + gridY0toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors0.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = photo;
          if (gridY1toImage < 0 && animationState != AnimationState.upward) {
            currentPhoto = photo2;
          } else if (gridY1toImage < 0 && animationState != AnimationState.downward) {
            currentPhoto = photo0;
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY1toImage >= 0 ? gridY1toImage.toInt() : photoSize + gridY1toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors1.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = photo;
          if (gridY2toImage < 0 && animationState != AnimationState.upward) {
            currentPhoto = photo2;
          } else if (gridY2toImage < 0 && animationState != AnimationState.downward) {
            currentPhoto = photo0;
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY2toImage >= 0 ? gridY2toImage.toInt() : photoSize + gridY2toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors2.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = photo;
          if (gridY3toImage < 0 && animationState != AnimationState.upward) {
            currentPhoto = photo2;
          } else if (gridY3toImage < 0 && animationState != AnimationState.downward) {
            currentPhoto = photo0;
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY3toImage >= 0 ? gridY3toImage.toInt() : photoSize + gridY3toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors3.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = photo;
          if (gridY4toImage < 0 && animationState != AnimationState.upward) {
            currentPhoto = photo2;
          } else if (gridY4toImage < 0 && animationState != AnimationState.downward) {
            currentPhoto = photo0;
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY4toImage >= 0 ? gridY4toImage.toInt() : photoSize + gridY4toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          tappedColors4.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          // Adjust position back to display space
          tapPositions0.add(Offset(gridX, gridY0));
          tapPositions1.add(Offset(gridX, gridY1));
          tapPositions2.add(Offset(gridX, gridY2));
          tapPositions3.add(Offset(gridX, gridY3));
          tapPositions4.add(Offset(gridX, gridY4));
        }
      }
    }

    setState(() {});
    // sendPattern();
  }

  void sendPattern() {
    String leftString0 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors0, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String rightString0 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors0, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String leftString1 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors1, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String rightString1 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors1, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String leftString2 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors2, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String rightString2 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors2, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String leftString3 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors3, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String rightString3 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors3, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String leftString4 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors4, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String rightString4 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors4, cursorValues, isHorizontal: isActuatorsHorizontal).toString().padLeft(3, '0');
    String data = "<$leftString0$rightString0$leftString1$rightString1$leftString2$rightString2$leftString3$rightString3$leftString4$rightString4>";

    // Check if the data to be sent is different from the last sent pattern
    if (data != lastSentPattern) {
      sl<BluetoothBloc>().add(WriteDataEvent(data));
      print("Pattern sent: $data");
      lastSentPattern = data; // Update the last sent pattern
    } else {
      // print("Pattern not sent, identical to last pattern.");
    }
  }
}
