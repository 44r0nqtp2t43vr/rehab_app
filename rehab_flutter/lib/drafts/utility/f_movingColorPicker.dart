import 'dart:async';
import 'dart:math';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img; // Correct aliasing

class ColorPickerWidget extends StatefulWidget {
  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  String imagePath = 'assets/images/letters.jpg';
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

  bool useSnapshot = true;
  late GlobalKey currentKey;

  final StreamController<Color> _stateController = StreamController<Color>();
  late img.Image photo; // Correctly using img.Image
  Offset cursorPosition = Offset(20, 20);

  @override
  void initState() {
    super.initState();
    currentKey = useSnapshot ? paintKey : imageKey;
    _loadImage(); // Make sure this method is defined and called correctly
  }

  @override
  Widget build(BuildContext context) {
    final String title = useSnapshot ? "Snapshot" : "Basic";
    return Scaffold(
      appBar: AppBar(title: Text("Color Picker $title")),
      body: StreamBuilder<Color>(
          initialData: Colors.green[500],
          stream: _stateController.stream,
          builder: (context, snapshot) {
            Color selectedColor = snapshot.data ?? Colors.green;
            return Stack(
              children: <Widget>[
                RepaintBoundary(
                  key: paintKey,
                  child: GestureDetector(
                    onPanDown: (details) {
                      // When the user taps on the screen, update the cursorPosition
                      setState(() {
                        cursorPosition = details.globalPosition;
                      });
                      searchPixel(details.globalPosition);
                    },
                    onPanUpdate: (details) {
                      // When the user moves their finger, update the cursorPosition
                      setState(() {
                        cursorPosition = details.globalPosition;
                      });
                      searchPixel(details.globalPosition);
                    },
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        key: imageKey,
                      ),
                    ),
                  ),
                ),
                colorPickerCursor(selectedColor, cursorPosition)
              ],
            );
          }),
    );
  }

  Widget colorPickerCursor(Color selectedColor, Offset cursorPosition) {
    // Calculate the position for centering the cursor based on the cursorPosition
    double cursorLeft =
        cursorPosition.dx - 10; // Adjust for centering the cursor horizontally
    double cursorBottom = MediaQuery.of(context).size.height -
        cursorPosition.dy -
        10; // Adjust for centering the cursor vertically

    return Positioned(
      left: cursorLeft,
      bottom: cursorBottom,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedColor,
          border: Border.all(width: 2.0, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 2, // Width of the crosshair line
            height: 20, // Height of the crosshair line
            color: Colors.white, // Color of the crosshair
          ),
        ),
      ),
    );
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox? box =
        currentKey.currentContext?.findRenderObject() as RenderBox?;

    if (box != null) {
      Offset localPosition = box.globalToLocal(globalPosition);

      // Adjusting for the image scaling
      Size imageSize = Size(photo.width.toDouble(),
          photo.height.toDouble()); // Original image size
      Size widgetSize = box.size; // Widget size
      double scaleX = widgetSize.width / imageSize.width;
      double scaleY = widgetSize.height / imageSize.height;
      double scale = min(scaleX, scaleY);
      double dx = (widgetSize.width - imageSize.width * scale) / 2;
      double dy = (widgetSize.height - imageSize.height * scale) / 2;
      Offset adjustedLocalPosition = Offset(
        (localPosition.dx - dx) / scale,
        (localPosition.dy - dy) / scale,
      );

      // Ensure the adjusted position is within the image bounds
      if (adjustedLocalPosition.dx >= 0 &&
          adjustedLocalPosition.dx < photo.width &&
          adjustedLocalPosition.dy >= 0 &&
          adjustedLocalPosition.dy < photo.height) {
        // Sample size for averaging (3x3 area around the touch point)
        const int sampleRadius = 1;
        List<int> rValues = [];
        List<int> gValues = [];
        List<int> bValues = [];
        List<int> aValues = [];

        for (int x = -sampleRadius; x <= sampleRadius; x++) {
          for (int y = -sampleRadius; y <= sampleRadius; y++) {
            int sampleX = adjustedLocalPosition.dx.toInt() + x;
            int sampleY = adjustedLocalPosition.dy.toInt() + y;

            if (sampleX >= 0 &&
                sampleX < photo.width &&
                sampleY >= 0 &&
                sampleY < photo.height) {
              img.Pixel samplePixel = photo.getPixelSafe(sampleX, sampleY);
              rValues.add(samplePixel.r.toInt());
              gValues.add(samplePixel.g.toInt());
              bValues.add(samplePixel.b.toInt());
              aValues.add(samplePixel.a.toInt());
            }
          }
        }

        int avgR = rValues.isNotEmpty
            ? rValues.reduce((a, b) => a + b) ~/ rValues.length
            : 0;
        int avgG = gValues.isNotEmpty
            ? gValues.reduce((a, b) => a + b) ~/ gValues.length
            : 0;
        int avgB = bValues.isNotEmpty
            ? bValues.reduce((a, b) => a + b) ~/ bValues.length
            : 0;
        int avgA = aValues.isNotEmpty
            ? aValues.reduce((a, b) => a + b) ~/ aValues.length
            : 0;

        int hex = (avgA << 24) | (avgR << 16) | (avgG << 8) | avgB;
        Color averageColor = Color(hex);

        // Use the averageColor for the rest of your logic
        _determineCursorColor(averageColor);
      } else {
        print("Touch is outside the bounds of the image.");
      }
    } else {
      print("RenderBox was null, cannot calculate pixel.");
    }
  }

  void _determineCursorColor(Color averageColor) {
    int averageColorValue =
        (averageColor.red + averageColor.green + averageColor.blue) ~/ 3;
    const int darkGreyThreshold = 100;

    if (averageColorValue <= darkGreyThreshold) {
      _stateController.add(Colors.green);
    } else {
      _stateController.add(Colors.white);
    }
  }

// Correct handling of ByteData?
  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary? boundary =
        paintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary != null) {
      ui.Image capture = await boundary.toImage();
      ByteData? imageBytes =
          await capture.toByteData(format: ui.ImageByteFormat.png);

      if (imageBytes != null) {
        setImageBytes(imageBytes);
      }
      capture.dispose();
    }
  }

  void setImageBytes(ByteData imageBytes) {
    Uint8List values = imageBytes.buffer.asUint8List();
    img.Image? decodedImage = img.decodeImage(values);
    if (decodedImage != null) {
      setState(() {
        photo = decodedImage;
      });
    } else {
      // Handle the case where the image could not be decoded
      print("Failed to decode image.");
    }
  }

  Future<void> loadImageBundleBytes() async {
    ByteData data = await rootBundle.load(imagePath);
    Uint8List bytes = data.buffer.asUint8List();
    setState(() {
      photo = img.decodeImage(bytes)!; // Ensure non-null; use ! or handle null
    });
  }

  // Converts color format from ABGR to ARGB which Flutter uses
  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  Future<void> _loadImage() async {
    ByteData data = await rootBundle.load(imagePath);
    Uint8List bytes = data.buffer.asUint8List();
    img.Image? decodedImage = img.decodeImage(bytes);
    if (decodedImage != null) {
      setState(() {
        photo = decodedImage;
      });
    } else {
      // Handle the case where the image could not be loaded
      print("Failed to load image from assets.");
    }
  }
}

void main() => runApp(MaterialApp(home: ColorPickerWidget()));
