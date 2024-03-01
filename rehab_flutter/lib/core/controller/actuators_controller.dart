import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/widgets/actuator.dart';
import 'package:rehab_flutter/injection_container.dart';

class ActuatorsController extends GetxController {
  final double actuatorSize = 6;
  final double actuatorSpacing = 10;
  final int actuatorsPerFinger = 16;
  late ActuatorsOrientation orientation;
  late ActuatorsNumOfFingers numOfFingers;
  late String lastSentPattern;
  late int imagesHeight;
  late int imagesWidth;

  List<img.Image> imagesToScan = [
    img.Image(height: 0, width: 0),
    img.Image(height: 0, width: 0),
    img.Image(height: 0, width: 0),
  ];

  Map<int, List<Offset>> positionsMap = {
    0: [],
    1: [],
    2: [],
    3: [],
    4: [],
  };

  Map<int, List<Color>> colorsMap = {
    0: [],
    1: [],
    2: [],
    3: [],
    4: [],
  };

  Future<void> initializeActuators({required ActuatorsOrientation orientation, required ActuatorsNumOfFingers numOfFingers, required String imgSrc, required int imagesHeight, required int imagesWidth}) async {
    this.orientation = orientation;
    this.numOfFingers = numOfFingers;
    this.imagesHeight = imagesHeight;
    this.imagesWidth = imagesWidth;
    lastSentPattern = "<000000000000000000000000000000>";
    await loadImage(src: imgSrc, preload: false);
  }

  int numOfFingersIntFromEnum() {
    switch (numOfFingers) {
      case ActuatorsNumOfFingers.one:
        return 1;
      case ActuatorsNumOfFingers.five:
        return 5;
    }
  }

  List<int> actuatorValuesFromOrientation() {
    switch (orientation) {
      case ActuatorsOrientation.landscape:
        return [1, 8, 1, 8, 2, 16, 2, 16, 4, 32, 4, 32, 64, 128, 64, 128];
      case ActuatorsOrientation.portrait:
        return [64, 4, 2, 1, 128, 32, 16, 8, 64, 4, 2, 1, 128, 32, 16, 8];
    }
  }

  List<Widget> buildActuators() {
    List<Widget> actuators = [];
    for (int i = 0; i < numOfFingersIntFromEnum(); i++) {
      for (int j = 0; j < positionsMap[i]!.length; j++) {
        actuators.add(Actuator(
          tapPosition: positionsMap[i]![j],
          tappedColor: colorsMap[i]![j],
          size: actuatorSize,
        ));
      }
    }
    return actuators;
  }

  void resetActuators() {
    positionsMap.forEach((key, value) {
      value.clear();
    });
    colorsMap.forEach((key, value) {
      value.clear();
    });
  }

  Future<void> loadImage({required String src, required bool preload}) async {
    try {
      ByteData data = await rootBundle.load(src);
      Uint8List bytes = data.buffer.asUint8List();
      img.Image image = img.decodeImage(bytes)!;

      image = img.copyResize(image, width: imagesWidth, height: imagesHeight, maintainAspect: false);

      if (preload) {
        imagesToScan[1] = image;
      } else {
        imagesToScan[0] = image;
      }
    } catch (e) {
      debugPrint("Failed to load image: $e");
    }
  }

  void updateActuators({required Offset position}) {
    double adjustedX = position.dx;
    double adjustedY = position.dy;

    positionsMap.forEach((key, value) {
      value.clear();
    });
    colorsMap.forEach((key, value) {
      value.clear();
    });

    for (int i = -1; i <= 2; i++) {
      for (int j = -1; j <= 2; j++) {
        final double gridX0 = adjustedX - 80 + (j * actuatorSpacing);
        final double gridX1 = adjustedX - 40 + (j * actuatorSpacing);
        final double gridX2 = adjustedX + (j * actuatorSpacing);
        final double gridX3 = adjustedX + 40 + (j * actuatorSpacing);
        final double gridX4 = adjustedX + 80 + (j * actuatorSpacing);
        final double gridY = adjustedY + (i * actuatorSpacing);

        final int imageX0 = max(0, min(imagesWidth, gridX0.round()));
        final int imageX1 = max(0, min(imagesWidth, gridX1.round()));
        final int imageX2 = max(0, min(imagesWidth, gridX2.round()));
        final int imageX3 = max(0, min(imagesWidth, gridX3.round()));
        final int imageX4 = max(0, min(imagesWidth, gridX4.round()));
        final int imageY = max(0, min(imagesHeight, gridY.round()));

        img.Pixel pixel = imagesToScan[0].getPixelSafe(imageX0, imageY);
        bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        colorsMap[0]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = imagesToScan[0].getPixelSafe(imageX1, imageY);
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        colorsMap[1]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = imagesToScan[0].getPixelSafe(imageX2, imageY);
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        colorsMap[2]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = imagesToScan[0].getPixelSafe(imageX3, imageY);
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        colorsMap[3]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        pixel = imagesToScan[0].getPixelSafe(imageX4, imageY);
        isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        colorsMap[4]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        // Adjust position back to display space
        positionsMap[0]!.add(Offset(gridX0, gridY));
        positionsMap[1]!.add(Offset(gridX1, gridY));
        positionsMap[2]!.add(Offset(gridX2, gridY));
        positionsMap[3]!.add(Offset(gridX3, gridY));
        positionsMap[4]!.add(Offset(gridX4, gridY));
      }
    }

    sendPattern();
  }

  String actuatorSumStr({required int fingerNum, required bool isLeft}) {
    int sum = 0;
    List<int> values = actuatorValuesFromOrientation();

    if (isLeft) {
      if (orientation == ActuatorsOrientation.landscape) {
        for (int i = 0; i < actuatorsPerFinger; i += 4) {
          if (i < actuatorsPerFinger && colorsMap[fingerNum]![i] == Colors.green) {
            sum += values[i];
          }
          if (i + 1 < actuatorsPerFinger && colorsMap[fingerNum]![i + 1] == Colors.green) {
            sum += values[i + 1];
          }
        }
      } else if (orientation == ActuatorsOrientation.portrait) {
        for (int i = 0; i < 8; i++) {
          if (i < actuatorsPerFinger && colorsMap[fingerNum]![i] == Colors.green) {
            sum += values[i];
          }
        }
      }
    } else {
      if (orientation == ActuatorsOrientation.landscape) {
        for (int i = 2; i < actuatorsPerFinger; i += 4) {
          if (i < actuatorsPerFinger && colorsMap[fingerNum]![i] == Colors.green) {
            sum += values[i];
          }
          if (i + 1 < actuatorsPerFinger && colorsMap[fingerNum]![i + 1] == Colors.green) {
            sum += values[i + 1];
          }
        }
      } else if (orientation == ActuatorsOrientation.portrait) {
        for (int i = 8; i < 16; i++) {
          if (i < actuatorsPerFinger && colorsMap[fingerNum]![i] == Colors.green) {
            sum += values[i];
          }
        }
      }
    }

    return sum.toString().padLeft(3, '0');
  }

  void sendPattern() {
    String data = "<";
    if (numOfFingers == ActuatorsNumOfFingers.one) {
      data += "${actuatorSumStr(fingerNum: 0, isLeft: true)}${actuatorSumStr(fingerNum: 0, isLeft: false)}" * 5;
      data += ">";
      if (data != lastSentPattern) {
        sl<BluetoothBloc>().add(WriteDataEvent(data));
        lastSentPattern = data;
      }
    } else if (numOfFingers == ActuatorsNumOfFingers.five) {
      for (int i = 0; i < 5; i++) {
        data += "${actuatorSumStr(fingerNum: i, isLeft: true)}${actuatorSumStr(fingerNum: i, isLeft: false)}";
      }
      data += ">";
      if (data != lastSentPattern) {
        sl<BluetoothBloc>().add(WriteDataEvent(data));
        lastSentPattern = data;
      }
    }
  }
}
