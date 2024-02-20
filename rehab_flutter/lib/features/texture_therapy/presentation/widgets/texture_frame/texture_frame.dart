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
  TextureFrameState createState() => TextureFrameState();
}

class TextureFrameState extends State<TextureFrame> {
  late img.Image photo;
  List<Color> tappedColors = List.generate(16, (_) => Colors.transparent);
  List<Offset?> tapPositions = List.generate(16, (_) => null);

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
        // Optionally reset other state variables if needed
        tapPositions = List.generate(16, (_) => null); // Reset tap positions
        tappedColors = List.generate(16, (_) => Colors.transparent); // Reset tapped colors
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

    // Define grid size and spacing
    const int gridSize = 4;
    const double spacing = 10.0;

    List<Offset> localGridPositions = [];
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        double offsetX = (col - gridSize / 2) * spacing + localPosition.dx;
        double offsetY = (row - gridSize / 2) * spacing + localPosition.dy;
        localGridPositions.add(Offset(offsetX, offsetY));
      }
    }

    List<Color> localTappedColors = [];
    List<Offset?> localTapPositions = [];

    for (Offset pos in localGridPositions) {
      // Adjust and scale positions based on image and container
      double adjustedX, adjustedY;
      // Similar adjustment and scaling code as before for each position in localGridPositions

      // Ensure coordinates are within the image bounds
      final int imageX = max(0, min(photo.width - 1, adjustedX.round()));
      final int imageY = max(0, min(photo.height - 1, adjustedY.round()));

      final img.Pixel pixel = photo.getPixelSafe(imageX, imageY);

      // Determine color
      bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
      Color color = !isWhite
          ? Colors.green
          : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0);

      localTappedColors.add(color);
      localTapPositions.add(pos);
    }

    setState(() {
      tappedColors = localTappedColors;
      tapPositions = localTapPositions;
    });
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
          if (_tapPosition != null)
            SingleActuator(
                tapPosition: _tapPosition, tappedColor: tappedColor, value: 1),
        ],
      ),
    );
  }
}
