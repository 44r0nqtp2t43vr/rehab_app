import 'dart:math';
import 'dart:typed_data';

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
  final AudioPlayer player = AudioPlayer();
  late List<ImageTexture> imageTextures;
  late AnimationController animationController;
  late img.Image photo;
  int currentImgIndex = 0;
  bool hasStarted = true;
  bool isPlaying = true;
  List<Offset> tapPositions = [];
  List<Color> tappedColors = [];
  List<int> cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
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
      duration: const Duration(seconds: 5),
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (currentImgIndex == imageTextures.length - 3) {
          _onEnd();
        } else {
          setState(() {
            currentImgIndex++;
          });
          _loadImage();
          animationController.forward(from: 0);
        }
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
      ByteData data = await rootBundle.load(imageTextures[currentImgIndex].texture);
      Uint8List bytes = data.buffer.asUint8List();
      setState(() {
        photo = img.decodeImage(bytes)!;
        print("=======================================");
        print(photo.toString());
        print("=======================================");
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
          // Custom paint to draw the circle
          ...ActuatorGrid.buildActuators(tapPositions, tappedColors, cursorValues),
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
    });
    animationController.reset();
    player.play(AssetSource(widget.song.audioSource)).then((value) => animationController.forward());
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

    tapPositions.clear();
    tappedColors.clear();

    for (int i = -1; i <= 2; i++) {
      for (int j = -1; j <= 2; j++) {
        final double gridX = adjustedX + (j * spacing);
        final double gridY = adjustedY + (i * spacing);

        final int imageX = max(0, min(photo.width - 1, gridX.round()));
        final int imageY = max(0, min(photo.height - 1, gridY.round()));

        final img.Pixel pixel = photo.getPixelSafe(imageX, imageY);
        bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        // Adjust position back to display space
        tapPositions.add(Offset(gridX, gridY));
      }
    }

    setState(() {});
    sendPattern();
  }

  void sendPattern() {
    String leftString = ActuatorGrid.sumOfLeftActivatedActuators(tappedColors, cursorValues).toString().padLeft(3, '0');
    String rightString = ActuatorGrid.sumOfRightActivatedActuators(tappedColors, cursorValues).toString().padLeft(3, '0');
    String data = "<$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString$leftString$rightString>";

    // Check if the data to be sent is different from the last sent pattern
    if (data != lastSentPattern) {
      sl<BluetoothBloc>().add(WriteDataEvent(data));
      print("Pattern sent: $data");
      lastSentPattern = data; // Update the last sent pattern
    } else {
      print("Pattern not sent, identical to last pattern.");
    }
  }
}
