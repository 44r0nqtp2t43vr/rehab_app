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

class TextureFrame extends StatefulWidget {
  final ImageTexture imageTexture;

  const TextureFrame({Key? key, required this.imageTexture}) : super(key: key);

  @override
  TextureFrameState createState() => TextureFrameState(); // Adjusted here
}

class TextureFrameState extends State<TextureFrame> {
  late img.Image photo;
  List<Offset> tapPositions = [];
  List<Color> tappedColors = [];
  List<int> cursorValues = [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
  String lastSentPattern = "";

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      ByteData data = await rootBundle.load(widget.imageTexture.texture);
      Uint8List bytes = data.buffer.asUint8List();
      setState(() {
        photo = img.decodeImage(bytes)!;
        // for pos in _tapPositions null
        tapPositions.clear();
      });
    } catch (e) {
      print("Failed to load image: $e");
      // Handle error or set a default image/photo state
    }
  }

  void _onTapImage(BuildContext context, dynamic details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    final double displayWidth = box.size.width;
    final double displayHeight = box.size.height;
    final double scaleX = photo.width / displayWidth;
    final double scaleY = photo.height / displayHeight;

    double adjustedX = localPosition.dx;
    double adjustedY = localPosition.dy;

    if (photo.width / photo.height > displayWidth / displayHeight) {
      // Adjust for wide image
      double scaledHeight = displayWidth / (photo.width / photo.height);
      adjustedY = (localPosition.dy - (displayHeight - scaledHeight) / 2) * scaleY;
    } else {
      // Adjust for tall image
      double scaledWidth = displayHeight * (photo.width / photo.height);
      adjustedX = (localPosition.dx - (displayWidth - scaledWidth) / 2) * scaleX;
    }

    tapPositions.clear();
    tappedColors.clear();

    // Increase the spacing to 20 points instead of 10
    int spacing = 10; // Adjust the spacing value as needed

    // Correct loop to generate positions with increased spacing
    for (int i = -1; i <= 2; i++) {
      for (int j = -1; j <= 2; j++) {
        final double gridX = adjustedX + (j * spacing) * scaleX;
        final double gridY = adjustedY + (i * spacing) * scaleY;

        final int imageX = max(0, min(photo.width - 1, gridX.round()));
        final int imageY = max(0, min(photo.height - 1, gridY.round()));

        final img.Pixel pixel = photo.getPixelSafe(imageX, imageY);
        bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        tappedColors.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        // Adjust position back to display space
        tapPositions.add(Offset(gridX / scaleX, gridY / scaleY));
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

  @override
  void didUpdateWidget(TextureFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if imagePath has changed
    if (widget.imageTexture.texture != oldWidget.imageTexture.texture) {
      _loadImage(); // Reload the image if the path has changed
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapImage(context, details),
      onPanUpdate: (details) => _onTapImage(context, details),
      child: Stack(
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imageTexture.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Custom paint to draw the circle
          ...ActuatorGrid.buildActuators(tapPositions, tappedColors, cursorValues),
        ],
      ),
    );
  }
}
