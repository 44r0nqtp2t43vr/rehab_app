import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_frame/widget/actuator_grid.dart';
import 'package:rehab_flutter/injection_container.dart';

class ScrollTextureFrame extends StatefulWidget {
  final ImageTexture imageTexture;
  final AnimationController animationController;

  const ScrollTextureFrame({super.key, required this.imageTexture, required this.animationController});

  @override
  State<ScrollTextureFrame> createState() => _ScrollTextureFrameState();
}

class _ScrollTextureFrameState extends State<ScrollTextureFrame> {
  late img.Image photo;
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
  List<int> cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
  String lastSentPattern = "";

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      int desiredSize = 300;
      ByteData data = await rootBundle.load(widget.imageTexture.texture).then((value) {
        // Define your desired width and height for resizing
        desiredSize = MediaQuery.of(context).size.width.toInt();
        return value;
      });
      Uint8List bytes = data.buffer.asUint8List();
      img.Image image = img.decodeImage(bytes)!;

      // Resize the image
      image = img.copyResize(image, width: desiredSize, height: desiredSize, maintainAspect: false);

      setState(() {
        photo = image;
        tapPositions0.clear();
        tapPositions1.clear();
        tapPositions2.clear();
        tapPositions3.clear();
        tapPositions4.clear();
      });
    } catch (e) {
      print("Failed to load image: $e");
      // Handle error or set a default image/photo state
    }
  }

  void _onTapImage(BuildContext context, dynamic details, double imageSize) {
    int imageSizeInt = imageSize.toInt();

    RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    print(localPosition);

    double adjustedX = localPosition.dx;
    double adjustedY = localPosition.dy;

    // if (photo.width / photo.height > displayWidth / displayHeight) {
    //   // Adjust for wide image
    //   double scaledHeight = displayWidth / (photo.width / photo.height);
    //   adjustedY = (localPosition.dy - (displayHeight - scaledHeight) / 2) * scaleY;
    // } else {
    //   // Adjust for tall image
    //   double scaledWidth = displayHeight * (photo.width / photo.height);
    //   adjustedX = (localPosition.dx - (displayWidth - scaledWidth) / 2) * scaleX;
    // }

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

    // Increase the spacing to 20 points instead of 10
    int spacing = 15; // Adjust the spacing value as needed

    // Correct loop to generate positions with increased spacing
    for (int i = -1; i <= 2; i++) {
      for (int j = -1; j <= 2; j++) {
        final double gridX0 = adjustedX - 120 + (j * spacing);
        final double gridX1 = adjustedX - 60 + (j * spacing);
        final double gridX2 = adjustedX + (j * spacing);
        final double gridX3 = adjustedX + 60 + (j * spacing);
        final double gridX4 = adjustedX + 120 + (j * spacing);
        final double gridY = adjustedY + (i * spacing);

        final int imageX0 = max(0, min(imageSizeInt, gridX0.round()));
        final int imageX1 = max(0, min(imageSizeInt, gridX1.round()));
        final int imageX2 = max(0, min(imageSizeInt, gridX2.round()));
        final int imageX3 = max(0, min(imageSizeInt, gridX3.round()));
        final int imageX4 = max(0, min(imageSizeInt, gridX4.round()));
        final int imageY = max(0, min(imageSizeInt, gridY.round()));

        img.Pixel pixel = photo.getPixelSafe(imageX0, imageY);
        bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors0.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = photo.getPixelSafe(imageX1, imageY);
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors1.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = photo.getPixelSafe(imageX2, imageY);
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors2.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = photo.getPixelSafe(imageX3, imageY);
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors3.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = photo.getPixelSafe(imageX4, imageY);
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
    // sendPattern();
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
      print("Pattern not sent, identical to last pattern.");
    }
  }

  @override
  void didUpdateWidget(ScrollTextureFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if imagePath has changed
    if (widget.imageTexture.texture != oldWidget.imageTexture.texture) {
      _loadImage(); // Reload the image if the path has changed
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // print(widget.animationController.value);

    return GestureDetector(
      onTapDown: (details) => _onTapImage(context, details, screenWidth),
      onPanUpdate: (details) => _onTapImage(context, details, screenWidth),
      child: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imageTexture.texture),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Custom paint to draw the circle
          ...ActuatorGrid.buildActuators(tapPositions0, tappedColors0, cursorValues),
          ...ActuatorGrid.buildActuators(tapPositions1, tappedColors1, cursorValues),
          ...ActuatorGrid.buildActuators(tapPositions2, tappedColors2, cursorValues),
          ...ActuatorGrid.buildActuators(tapPositions3, tappedColors3, cursorValues),
          ...ActuatorGrid.buildActuators(tapPositions4, tappedColors4, cursorValues),
        ],
      ),
    );
  }
}
