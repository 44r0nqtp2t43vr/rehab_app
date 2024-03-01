// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:image/image.dart' as img;

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({super.key});

  @override
  ColorPickerWidgetState createState() => ColorPickerWidgetState();
}

class ColorPickerWidgetState extends State<ColorPickerWidget> {
  String imagePath = 'assets/images/MultipleTextures.png';
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

  bool useSnapshot = true;
  late GlobalKey currentKey;

  final StreamController<List<Color>> _stateController = StreamController<List<Color>>.broadcast();
  late img.Image photo;
  List<Offset> cursorPositions = List.generate(16, (_) => const Offset(20, 20));
  List<Color> cursorColors = List.generate(16, (_) => Colors.transparent);

  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  final String targetDeviceName = "Gloves_BLE_01";
  bool isDeviceConnected = false;

  String fingerString = '';
  Timer? _sendPatternTimer; // Corrected: Timer declared as a class member

  @override
  void initState() {
    super.initState();
    currentKey = useSnapshot ? paintKey : imageKey;
    startScan();
    _loadImage();
    _resetAndStartTimer(); // Moved timer initialization to initState
  }

  @override
  Widget build(BuildContext context) {
    final String title = useSnapshot ? "Snapshot" : "Basic";
    return Scaffold(
      appBar: AppBar(title: Text("Color Picker $title")),
      body: StreamBuilder<List<Color>>(
        initialData: List.generate(16, (_) => Colors.green[500]!),
        stream: _stateController.stream,
        builder: (context, snapshot) {
          final colors = snapshot.data ?? List.generate(16, (_) => Colors.green);
          return Stack(
            children: <Widget>[
              RepaintBoundary(
                key: paintKey,
                child: GestureDetector(
                  onPanDown: (details) => searchPixel(details.globalPosition),
                  onPanUpdate: (details) => searchPixel(details.globalPosition),
                  child: Center(
                    child: Image.asset(imagePath, key: imageKey),
                  ),
                ),
              ),
              ...fingerCursor(colors)
            ],
          );
        },
      ),
    );
  }

  List<int> cursorValues = [
    1,
    2,
    4,
    64,
    8,
    16,
    32,
    128,
  ];

  List<Widget> fingerCursor(List<Color> colors) {
    List<Widget> cursorWidgets = [];
    int leftActuatorSum = 0;
    int rightActuatorSum = 0;
    // Generate cursor widgets for left actuator (positions 0-7 and colors 0-7)
    for (int i = 0; i < 8; i++) {
      cursorWidgets.add(colorPickerCursor(colors[i], cursorPositions[i], cursorValues[i]));
    }
    // Generate cursor widgets for right actuator (positions 8-15 and colors 8-15)
    int x = 0;
    for (int i = 8; i < 16; i++) {
      cursorWidgets.add(colorPickerCursor(colors[i], cursorPositions[i], cursorValues[x]));
      x++;
    }
    for (int i = 0; i < 8; i++) {
      // Determine if the cursor is activated based on its color
      bool isActivated = !isColorCloseToWhite(colors[i]);

      // Add value to actuatorSum if the cursor is activated
      if (isActivated) {
        leftActuatorSum += cursorValues[i];
      }
    }
    x = 0;
    for (int i = 8; i < 16; i++) {
      // Determine if the cursor is activated based on its color
      bool isActivated = !isColorCloseToWhite(colors[i]);

      // Add value to actuatorSum if the cursor is activated
      if (isActivated) {
        rightActuatorSum += cursorValues[x];
      }
      x++;
    }

    String fingerStringLocal = leftActuatorSum.toString().padLeft(3, '0') + rightActuatorSum.toString().padLeft(3, '0');
    fingerStringLocal = "<$fingerString$fingerString$fingerString$fingerString$fingerString>";
    if (fingerStringLocal != fingerString) {
      sendPattern(fingerStringLocal);
      fingerString = fingerStringLocal;
      debugPrint("Different pattern");
    } else {
      debugPrint("Same pattern");
    }

    return cursorWidgets;
  }

  void _resetAndStartTimer() {
    _sendPatternTimer?.cancel(); // Cancel any existing timer
    _sendPatternTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (targetCharacteristic != null && fingerString.isNotEmpty) {
        targetCharacteristic!.write(Uint8List.fromList(fingerString.codeUnits));
      }
    });
  }

  // ignore: unused_element
  void _sendPatternSafely(String data) {
    if (targetCharacteristic == null) return;

    try {
      targetCharacteristic!.write(data.codeUnits);
      // Optional: Add logic here to handle successful send
    } catch (e) {
      // Handle any errors here
    }
  }

  List<Widget> actuatorCursor(List<Color> colors) {
    int actuatorSum = 0;
    List<Widget> cursorWidgets = [];
    // priint length of cursorValues, cursorPositions, and color

    for (int i = 0; i < cursorValues.length; i++) {
      // Determine if the cursor is activated based on its color
      bool isActivated = !isColorCloseToWhite(colors[i]);

      // Add value to actuatorSum if the cursor is activated
      if (isActivated) {
        actuatorSum += cursorValues[i];
      }

      // Generate the cursor widget
      Widget cursorWidget = colorPickerCursor(colors[i], cursorPositions[i], cursorValues[i]);
      cursorWidgets.add(cursorWidget);
      debugPrint("Actuator = $i");
    }

    // Pad actuatorSum to ensure it's a three-digit string
    String actuatorString = actuatorSum.toString().padLeft(3, '0');
    debugPrint(actuatorString); // Print the padded string

    return cursorWidgets;
  }

  bool isColorCloseToWhite(Color color) {
    // Assuming "close to white" means high values for R, G, and B
    int threshold = 240; // You can adjust this threshold
    return color.red > threshold && color.green > threshold && color.blue > threshold;
  }

// if color is not white, selectedColor = green, t
  Widget colorPickerCursor(Color selectedColor, Offset cursorPosition, int value) {
    bool isActivated = false;
    Timer? sendPatternTimer;

    // Check if the selectedColor is white or close to white
    // If not, set selectedColor to green
    if (!isColorCloseToWhite(selectedColor)) {
      selectedColor = Colors.green;
      isActivated = true;
    }
    double cursorLeft = cursorPosition.dx - 10;
    double cursorBottom = MediaQuery.of(context).size.height - cursorPosition.dy - 10;
    return Positioned(
      left: cursorLeft,
      bottom: cursorBottom,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedColor,
          border: Border.all(width: 2.0, color: Colors.white),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
      ),
    );
  }

  void searchPixel(Offset globalPosition) async {
    // ignore: unnecessary_null_comparison
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }

    int gridSize = 4;
    double step = 10.0;

    List<Offset> updatedPositions = [];
    for (int col = 0; col < gridSize; col++) {
      // Switched the loop order
      for (int row = 0; row < gridSize; row++) {
        // Switched the loop order
        Offset cursorOffset = Offset(
          (col - gridSize / 2) * step + globalPosition.dx,
          (row - gridSize / 2) * step + globalPosition.dy,
        );
        updatedPositions.add(cursorOffset);
        _calculatePixel(cursorOffset, index: col * gridSize + row); // Switched the index calculation
      }
    }

    setState(() {
      cursorPositions = updatedPositions;
    });
  }

  void _calculatePixel(Offset globalPosition, {required int index}) {
    RenderBox? box = currentKey.currentContext?.findRenderObject() as RenderBox?;

    // ignore: unnecessary_null_comparison
    if (box != null && photo != null) {
      Offset localPosition = box.globalToLocal(globalPosition);

      Size imageSize = Size(photo.width.toDouble(), photo.height.toDouble());
      Size widgetSize = box.size;
      double scaleX = widgetSize.width / imageSize.width;
      double scaleY = widgetSize.height / imageSize.height;
      double scale = min(scaleX, scaleY);
      double dx = (widgetSize.width - imageSize.width * scale) / 2;
      double dy = (widgetSize.height - imageSize.height * scale) / 2;
      Offset adjustedLocalPosition = Offset(
        (localPosition.dx - dx) / scale,
        (localPosition.dy - dy) / scale,
      );

      if (adjustedLocalPosition.dx >= 0 && adjustedLocalPosition.dx < photo.width && adjustedLocalPosition.dy >= 0 && adjustedLocalPosition.dy < photo.height) {
        const int sampleRadius = 1;
        List<int> rValues = [], gValues = [], bValues = [], aValues = [];

        for (int x = -sampleRadius; x <= sampleRadius; x++) {
          for (int y = -sampleRadius; y <= sampleRadius; y++) {
            int sampleX = adjustedLocalPosition.dx.toInt() + x;
            int sampleY = adjustedLocalPosition.dy.toInt() + y;

            if (sampleX >= 0 && sampleX < photo.width && sampleY >= 0 && sampleY < photo.height) {
              img.Pixel samplePixel = photo.getPixelSafe(sampleX, sampleY);
              // Explicitly convert to int before adding to the lists
              rValues.add(samplePixel.r.toInt());
              gValues.add(samplePixel.g.toInt());
              bValues.add(samplePixel.b.toInt());
              aValues.add(samplePixel.a.toInt());
            }
          }
        }

        int avgR = rValues.isNotEmpty ? rValues.reduce((a, b) => a + b) ~/ rValues.length : 0;
        int avgG = gValues.isNotEmpty ? gValues.reduce((a, b) => a + b) ~/ gValues.length : 0;
        int avgB = bValues.isNotEmpty ? bValues.reduce((a, b) => a + b) ~/ bValues.length : 0;
        int avgA = aValues.isNotEmpty ? aValues.reduce((a, b) => a + b) ~/ aValues.length : 255; // Ensure opacity

        Color averageColor = Color((avgA << 24) | (avgR << 16) | (avgG << 8) | avgB);

        // Update the cursor color
        cursorColors[index] = averageColor;
        _stateController.add(List.from(cursorColors)); // Update the stream with the new colors
      }
    }
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary? boundary = paintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary != null) {
      ui.Image capture = await boundary.toImage(pixelRatio: 3.0); // Higher resolution
      ByteData? imageBytes = await capture.toByteData(format: ui.ImageByteFormat.png);

      if (imageBytes != null) {
        setImageBytes(imageBytes);
      }
      capture.dispose(); // Release the ui.Image resource
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
      debugPrint("Failed to decode image.");
    }
  }

  Future<void> loadImageBundleBytes() async {
    ByteData data = await rootBundle.load(imagePath);
    Uint8List bytes = data.buffer.asUint8List();
    setState(() {
      photo = img.decodeImage(bytes)!;
    });
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
      debugPrint("Failed to load image from assets.");
    }
  }

  void startScan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        debugPrint(result.device.platformName);
        if (result.device.platformName == targetDeviceName) {
          debugPrint("Device found: ${result.device.platformName}");
          FlutterBluePlus.stopScan();
          setState(() {
            targetDevice = result.device;
          });
          connectToDevice();
          break;
        }
      }
    });
  }

  void connectToDevice() async {
    if (targetDevice != null) {
      await targetDevice!.connect();
      debugPrint("Device connected");
      setState(() {
        isDeviceConnected = true;
      });
      discoverServices();
    }
  }

  void discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice!.discoverServices();
    for (var service in services) {
      // Match the service UUID of your device
      if (service.uuid.toString().toUpperCase() == "0000FFE0-0000-1000-8000-00805F9B34FB") {
        for (var characteristic in service.characteristics) {
          // Match the characteristic UUID for sending data
          if (characteristic.uuid.toString().toUpperCase() == "0000FFE2-0000-1000-8000-00805F9B34FB") {
            targetCharacteristic = characteristic;
          }
        }
      }
    }
  }

  void sendPattern(String data) {
    if (targetCharacteristic == null) return;

    targetCharacteristic!.write(data.codeUnits);
    // print("Pattern sent: $data");
  }

  @override
  void dispose() {
    _stateController.close();
    _sendPatternTimer?.cancel(); // Ensure the timer is cancelled on dispose
    if (isDeviceConnected) {
      targetDevice?.disconnect(); // Disconnect from the device if connected
    }
    super.dispose();
  }
}

void main() => runApp(const MaterialApp(home: ColorPickerWidget()));
