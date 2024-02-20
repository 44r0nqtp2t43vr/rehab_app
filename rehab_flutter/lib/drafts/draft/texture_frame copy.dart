import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_frame/widget/single_actuator.dart';

class TextureFrame extends StatefulWidget {
  final ImageTexture imageTexture;

  const TextureFrame({Key? key, required this.imageTexture}) : super(key: key);

  @override
  TextureFrameState createState() => TextureFrameState(); // Adjusted here
}

class TextureFrameState extends State<TextureFrame> {
  late img.Image photo;
  Color tappedColor = Colors.transparent;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(TextureFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if imagePath has changed
    if (widget.imageTexture.texture != oldWidget.imageTexture.texture) {
      _loadImage(); // Reload the image if the path has changed
    }
  }

  Future<void> _loadImage() async {
    try {
      ByteData data = await rootBundle.load(widget.imageTexture.texture);
      Uint8List bytes = data.buffer.asUint8List();
      setState(() {
        photo = img.decodeImage(bytes)!;
        // Optionally reset other state variables if needed
        _tapPosition =
            null; // Reset tap position if you want to start fresh for new image
      });
    } catch (e) {
      print("Failed to load image: $e");
      // Handle error or set a default image/photo state
    }
  }

  void _onTapImage(BuildContext context, dynamic details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    // Calculate the display scale factor for the image
    final double displayWidth = box.size.width;
    final double displayHeight = box.size.height;
    final double scaleX = photo.width / displayWidth;
    final double scaleY = photo.height / displayHeight;

    // Calculate the aspect ratio of the image and the container
    final double imageAspectRatio = photo.width / photo.height;
    final double containerAspectRatio = displayWidth / displayHeight;

    // Adjust coordinates based on how the image fits within the container
    double adjustedX = localPosition.dx;
    double adjustedY = localPosition.dy;

    if (imageAspectRatio > containerAspectRatio) {
      // Image is wider than container
      final double scaledHeight = displayWidth / imageAspectRatio;
      final double yOffset = (displayHeight - scaledHeight) / 2;
      adjustedY = (localPosition.dy - yOffset) * scaleY;
      adjustedX = localPosition.dx * scaleX;
    } else {
      // Image is taller than container or has the same aspect ratio
      final double scaledWidth = displayHeight * imageAspectRatio;
      final double xOffset = (displayWidth - scaledWidth) / 2;
      adjustedX = (localPosition.dx - xOffset) * scaleX;
      adjustedY = localPosition.dy * scaleY;
    }

    // Ensure coordinates are within the image bounds
    final int imageX = max(0, min(photo.width - 1, adjustedX.round()));
    final int imageY = max(0, min(photo.height - 1, adjustedY.round()));

    final img.Pixel pixel = photo.getPixelSafe(imageX, imageY);

    // White color detection and setting tapped color
    bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
    setState(() {
      tappedColor = !isWhite
          ? Colors.green
          : Color.fromRGBO(
              pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0);
      _tapPosition = localPosition;
    });
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
          if (_tapPosition != null)
            SingleActuator(
                tapPosition: _tapPosition, tappedColor: tappedColor, value: 1),
        ],
      ),
    );
  }
}
