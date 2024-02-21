import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/song.dart';
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

class _ScrollTexturesState extends State<ScrollTextures> with SingleTickerProviderStateMixin {
  final List<int> cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
  final AudioPlayer player = AudioPlayer();
  late List<ImageTexture> imageTextures;
  late AnimationController animationController;
  late img.Image photo;
  late img.Image photo2;
  int currentImgIndex = 0;
  bool hasStarted = true;
  bool isPlaying = true;
  bool isPreloaded = false;
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

  @override
  void initState() {
    super.initState();
    // notes = List.from(widget.song.songNotes);
    imageTextures = List.from([
      ...ImageTextureProvider().imageTextures,
      ...[ImageTexture(name: "", image: "", texture: ""), ImageTexture(name: "", image: "", texture: "")]
    ]);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (currentImgIndex == imageTextures.length - 3) {
          _onEnd();
        } else {
          setState(() {
            currentImgIndex++;
            photo = photo2;
            isPreloaded = false;
          });
          // _loadImage();

          animationController.forward(from: 0);
        }
      }
    });

    animationController.addListener(() {
      if (animationController.value >= 0.85 && !isPreloaded && currentImgIndex < imageTextures.length - 3) {
        _loadImage2();
      }
    });

    _loadImage().then((value) {
      animationController.addListener(() {
        _onPass(context);
      });
    });

    player.play(AssetSource(widget.song.audioSource)).then((value) => animationController.forward());
  }

  @override
  void dispose() {
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    animationController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    try {
      int desiredWidth = 300;
      int desiredHeight = 300;
      ByteData data = await rootBundle.load(imageTextures[currentImgIndex].texture).then((value) {
        // Define your desired width and height for resizing
        desiredWidth = MediaQuery.of(context).size.width.toInt();
        desiredHeight = MediaQuery.of(context).size.height ~/ 2;
        return value;
      });
      Uint8List bytes = data.buffer.asUint8List();
      img.Image image = img.decodeImage(bytes)!;

      // Resize the image
      img.Image resizedImage = img.copyResize(image, width: desiredWidth, height: desiredHeight);

      setState(() {
        photo = resizedImage;
      });
    } catch (e) {
      print("Failed to load image: $e");
      // Handle error or set a default image/photo state
    }
  }

  Future<void> _loadImage2() async {
    try {
      int desiredWidth = 300;
      int desiredHeight = 300;
      ByteData data = await rootBundle.load(imageTextures[currentImgIndex + 1].texture).then((value) {
        // Define your desired width and height for resizing
        desiredWidth = MediaQuery.of(context).size.width.toInt();
        desiredHeight = MediaQuery.of(context).size.height ~/ 2;
        return value;
      });
      Uint8List bytes = data.buffer.asUint8List();
      img.Image image = img.decodeImage(bytes)!;

      // Resize the image
      img.Image resizedImage = img.copyResize(image, width: desiredWidth, height: desiredHeight);

      setState(() {
        photo2 = resizedImage;
        isPreloaded = true;
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
    setState(() {
      imageTextures = List.from([
        ...ImageTextureProvider().imageTextures,
        ...[ImageTexture(name: "", image: "", texture: ""), ImageTexture(name: "", image: "", texture: "")]
      ]);
      currentImgIndex = 0;
      hasStarted = true;
      isPlaying = true;
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
    });
    animationController.reset();
    _loadImage().then((value) {
      player.play(AssetSource(widget.song.audioSource)).then((value) => animationController.forward());
    });
  }

  void _onEnd() {
    player.stop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Play again?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restart();
              },
              child: const Text("Restart"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  _drawGallery(double imgHeight, double imgWidth) {
    return Expanded(
      child: Gallery(
        imgHeight: imgHeight,
        imgWidth: imgWidth,
        // imageTextures: imageTextures,
        imageTextures: imageTextures.sublist(currentImgIndex, currentImgIndex + 3),
        currentImgIndex: currentImgIndex,
        animation: animationController,
        key: GlobalKey(),
      ),
    );
  }

  void _onPass(BuildContext context) {
    final double adjustedX = MediaQuery.of(context).size.width / 2 + 7; // Adjust as needed
    final double adjustedY = MediaQuery.of(context).size.height - 40; // Bottom of the screen
    int spacing = 15; // Adjust the spacing value as needed

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
        // final int imageY = max(0, min(photo.height - 1, gridY.round()));

        // if (i == -1 && j == -1) {
        //   print("${animationController.value}, ($gridX2, $gridY), ($imageX2, $gridYtoImage)");
        // }

        img.Image currentPhoto = gridYtoImage >= 0 ? photo : photo2;

        img.Pixel pixel = currentPhoto.getPixelSafe(imageX0, gridYtoImage >= 0 ? gridYtoImage.toInt() : photo2.height + gridYtoImage.toInt());
        bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors0.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = currentPhoto.getPixelSafe(imageX1, gridYtoImage >= 0 ? gridYtoImage.toInt() : photo2.height + gridYtoImage.toInt());
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors1.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = currentPhoto.getPixelSafe(imageX2, gridYtoImage >= 0 ? gridYtoImage.toInt() : photo2.height + gridYtoImage.toInt());
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors2.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = currentPhoto.getPixelSafe(imageX3, gridYtoImage >= 0 ? gridYtoImage.toInt() : photo2.height + gridYtoImage.toInt());
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors3.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = currentPhoto.getPixelSafe(imageX4, gridYtoImage >= 0 ? gridYtoImage.toInt() : photo2.height + gridYtoImage.toInt());
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

    setState(() {});
    sendPattern();
  }

  void sendPattern() {
    String leftString0 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors0, cursorValues).toString().padLeft(3, '0');
    String rightString0 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors0, cursorValues).toString().padLeft(3, '0');
    String leftString1 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors1, cursorValues).toString().padLeft(3, '0');
    String rightString1 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors1, cursorValues).toString().padLeft(3, '0');
    String leftString2 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors2, cursorValues).toString().padLeft(3, '0');
    String rightString2 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors2, cursorValues).toString().padLeft(3, '0');
    String leftString3 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors3, cursorValues).toString().padLeft(3, '0');
    String rightString3 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors3, cursorValues).toString().padLeft(3, '0');
    String leftString4 = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors4, cursorValues).toString().padLeft(3, '0');
    String rightString4 = ActuatorGrid.sumOfRightActivatedActuators(tappedColors4, cursorValues).toString().padLeft(3, '0');
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
