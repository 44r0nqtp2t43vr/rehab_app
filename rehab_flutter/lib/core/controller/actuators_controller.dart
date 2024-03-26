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
  final int spaceBetweenFingers = 50;
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

  List<Widget> buildActuatorsConstColor() {
    List<Widget> actuators = [];
    for (int i = 0; i < numOfFingersIntFromEnum(); i++) {
      for (int j = 0; j < positionsMap[i]!.length; j++) {
        actuators.add(Actuator(
          tapPosition: positionsMap[i]![j],
          tappedColor: Colors.white,
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

  Future<void> loadImage({required String src, required bool preload, int rotateFactor = 0}) async {
    try {
      ByteData data = await rootBundle.load(src);
      Uint8List bytes = data.buffer.asUint8List();
      img.Image image = img.decodeImage(bytes)!;

      if (imagesHeight > 0 && imagesWidth > 0) {
        image = img.copyResize(image, width: imagesWidth, height: imagesHeight, maintainAspect: false);
      } else {
        imagesWidth = image.width;
        imagesHeight = image.height;
      }

      // Rotate the image
      if (preload && rotateFactor > 0) {
        image = img.copyRotate(image, angle: 90 * rotateFactor);
      }

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
    resetActuators();

    double adjustedX = position.dx;
    double adjustedY = position.dy;

    for (int i = -1; i <= 2; i++) {
      for (int j = -1; j <= 2; j++) {
        final double gridX2 = adjustedX + (j * actuatorSpacing);
        final double gridY = adjustedY + (i * actuatorSpacing);

        final int imageX2 = max(0, min(imagesWidth, gridX2.round()));
        final int imageY = max(0, min(imagesHeight, gridY.round()));

        img.Pixel pixel = imagesToScan[0].getPixelSafe(imageX2, imageY);
        bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
        colorsMap[0]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

        positionsMap[0]!.add(Offset(gridX2, gridY));

        if (numOfFingers == ActuatorsNumOfFingers.five) {
          final double gridX3 = adjustedX + spaceBetweenFingers + (j * actuatorSpacing);
          final double gridX4 = adjustedX + (spaceBetweenFingers * 2) + (j * actuatorSpacing);
          final double gridX0 = adjustedX - (spaceBetweenFingers * 2) + (j * actuatorSpacing);
          final double gridX1 = adjustedX - spaceBetweenFingers + (j * actuatorSpacing);

          final int imageX0 = max(0, min(imagesWidth, gridX0.round()));
          final int imageX1 = max(0, min(imagesWidth, gridX1.round()));
          final int imageX3 = max(0, min(imagesWidth, gridX3.round()));
          final int imageX4 = max(0, min(imagesWidth, gridX4.round()));

          pixel = imagesToScan[0].getPixelSafe(imageX0, imageY);
          bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[1]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = imagesToScan[0].getPixelSafe(imageX1, imageY);
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[2]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = imagesToScan[0].getPixelSafe(imageX3, imageY);
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[3]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = imagesToScan[0].getPixelSafe(imageX4, imageY);
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[4]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          positionsMap[1]!.add(Offset(gridX0, gridY));
          positionsMap[2]!.add(Offset(gridX1, gridY));
          positionsMap[3]!.add(Offset(gridX3, gridY));
          positionsMap[4]!.add(Offset(gridX4, gridY));
        }
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

  void updateActuatorsScrollingAnimation({required double animationValue, required double animationHorizValue, required bool isLastVertStateDownward}) {
    resetActuators();

    if (orientation == ActuatorsOrientation.landscape) {
      final double adjustedX = imagesWidth / 2;
      final double adjustedY = (imagesHeight * 2) - 40;

      for (int i = -1; i <= 2; i++) {
        for (int j = -1; j <= 2; j++) {
          final double gridX0 = adjustedX - (spaceBetweenFingers * 2) + (j * actuatorSpacing);
          final double gridX1 = adjustedX - spaceBetweenFingers + (j * actuatorSpacing);
          final double gridX2 = adjustedX + (j * actuatorSpacing);
          final double gridX3 = adjustedX + spaceBetweenFingers + (j * actuatorSpacing);
          final double gridX4 = adjustedX + (spaceBetweenFingers * 2) + (j * actuatorSpacing);
          final double gridY = adjustedY + (i * actuatorSpacing);

          final double gridYtoImage = (imagesHeight - 1 - 40 + (i * actuatorSpacing)) - ((imagesHeight - 1) * animationValue);

          final int imageX0 = max(0, min(imagesWidth - 1, gridX0.round()));
          final int imageX1 = max(0, min(imagesWidth - 1, gridX1.round()));
          final int imageX2 = max(0, min(imagesWidth - 1, gridX2.round()));
          final int imageX3 = max(0, min(imagesWidth - 1, gridX3.round()));
          final int imageX4 = max(0, min(imagesWidth - 1, gridX4.round()));

          // if (i == 2 && j == 2) {
          //   print("${animationController.value}, ($gridX2, $gridY), ($imageX2, $gridYtoImage), ${gridYtoImage >= 0}");
          // }

          img.Image currentPhoto = imagesToScan[0];
          if (gridYtoImage < 0 && isLastVertStateDownward) {
            currentPhoto = imagesToScan[1];
          } else if (gridYtoImage < 0) {
            currentPhoto = imagesToScan[2];
          }

          img.Pixel pixel = currentPhoto.getPixelSafe(imageX0, gridYtoImage >= 0 ? gridYtoImage.toInt() : imagesHeight + gridYtoImage.toInt());
          bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[1]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX1, gridYtoImage >= 0 ? gridYtoImage.toInt() : imagesHeight + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[2]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX2, gridYtoImage >= 0 ? gridYtoImage.toInt() : imagesHeight + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[0]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX3, gridYtoImage >= 0 ? gridYtoImage.toInt() : imagesHeight + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[3]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          pixel = currentPhoto.getPixelSafe(imageX4, gridYtoImage >= 0 ? gridYtoImage.toInt() : imagesHeight + gridYtoImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[4]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          positionsMap[1]!.add(Offset(gridX0, gridY));
          positionsMap[2]!.add(Offset(gridX1, gridY));
          positionsMap[0]!.add(Offset(gridX2, gridY));
          positionsMap[3]!.add(Offset(gridX3, gridY));
          positionsMap[4]!.add(Offset(gridX4, gridY));
        }
      }
    } else {
      const double adjustedX = 40;
      final double adjustedY = (imagesHeight * 2) / 4 * 3;

      for (int i = -1; i <= 2; i++) {
        for (int j = -1; j <= 2; j++) {
          final double gridX = adjustedX + (j * actuatorSpacing) + ((imagesWidth - 80) * animationHorizValue);
          final double gridY0 = adjustedY - 100 + (i * actuatorSpacing);
          final double gridY1 = adjustedY - 50 + (i * actuatorSpacing);
          final double gridY2 = adjustedY + (i * actuatorSpacing);
          final double gridY3 = adjustedY + 50 + (i * actuatorSpacing);
          final double gridY4 = adjustedY + 100 + (i * actuatorSpacing);

          // final double gridYtoImage = (photo.height - 1 - 40 + (i * spacing)) - ((photo.height - 1) * animationController.value);
          final double gridY0toImage = gridY0 - imagesHeight - ((imagesHeight - 1) * animationValue);
          final double gridY1toImage = gridY1 - imagesHeight - ((imagesHeight - 1) * animationValue);
          final double gridY2toImage = gridY2 - imagesHeight - ((imagesHeight - 1) * animationValue);
          final double gridY3toImage = gridY3 - imagesHeight - ((imagesHeight - 1) * animationValue);
          final double gridY4toImage = gridY4 - imagesHeight - ((imagesHeight - 1) * animationValue);

          final int imageX = max(0, min(imagesWidth - 1, gridX.round()));

          // if (i == -1 && j == -1) {
          //   // print("${animationController.value}, ($gridX, $gridY0), ($imageX, $gridY0toImage), ${gridY0toImage >= 0}");
          //   print("($gridY0, $gridY0toImage), ($gridY1, $gridY1toImage), ($gridY2, $gridY2toImage), ($gridY3, $gridY3toImage), ($gridY4, $gridY4toImage)");
          // }

          img.Pixel pixel;
          bool isWhite;
          img.Image currentPhoto = imagesToScan[0];

          if (gridY0toImage < 0 && isLastVertStateDownward == true) {
            currentPhoto = imagesToScan[1];
          } else if (gridY0toImage < 0 && isLastVertStateDownward == false) {
            currentPhoto = imagesToScan[2];
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY0toImage >= 0 ? gridY0toImage.toInt() : imagesHeight + gridY0toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[1]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = imagesToScan[0];
          if (gridY1toImage < 0 && isLastVertStateDownward == true) {
            currentPhoto = imagesToScan[1];
          } else if (gridY1toImage < 0 && isLastVertStateDownward == false) {
            currentPhoto = imagesToScan[2];
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY1toImage >= 0 ? gridY1toImage.toInt() : imagesHeight + gridY1toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[2]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = imagesToScan[0];
          if (gridY2toImage < 0 && isLastVertStateDownward == true) {
            currentPhoto = imagesToScan[1];
          } else if (gridY2toImage < 0 && isLastVertStateDownward == false) {
            currentPhoto = imagesToScan[2];
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY2toImage >= 0 ? gridY2toImage.toInt() : imagesHeight + gridY2toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[0]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = imagesToScan[0];
          if (gridY3toImage < 0 && isLastVertStateDownward == true) {
            currentPhoto = imagesToScan[1];
          } else if (gridY3toImage < 0 && isLastVertStateDownward == false) {
            currentPhoto = imagesToScan[2];
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY3toImage >= 0 ? gridY3toImage.toInt() : imagesHeight + gridY3toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[3]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          currentPhoto = imagesToScan[0];
          if (gridY4toImage < 0 && isLastVertStateDownward == true) {
            currentPhoto = imagesToScan[1];
          } else if (gridY4toImage < 0 && isLastVertStateDownward == false) {
            currentPhoto = imagesToScan[2];
          }
          pixel = currentPhoto.getPixelSafe(imageX, gridY4toImage >= 0 ? gridY4toImage.toInt() : imagesHeight + gridY4toImage.toInt());
          isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
          colorsMap[4]!.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

          // Adjust position back to display space
          positionsMap[1]!.add(Offset(gridX, gridY0));
          positionsMap[2]!.add(Offset(gridX, gridY1));
          positionsMap[0]!.add(Offset(gridX, gridY2));
          positionsMap[3]!.add(Offset(gridX, gridY3));
          positionsMap[4]!.add(Offset(gridX, gridY4));
        }
      }
    }

    sendPattern();
  }

  void rotateImages() {
    img.Image newPhoto0 = imagesToScan[2];
    img.Image newPhoto1 = imagesToScan[0];
    img.Image newPhoto2 = imagesToScan[1];

    if (newPhoto0.height != 0 && newPhoto0.width != 0) {
      newPhoto0 = img.copyRotate(newPhoto0, angle: 90);
      newPhoto0 = img.copyResize(newPhoto0, width: imagesWidth, height: imagesHeight, maintainAspect: false);
    }
    if (newPhoto1.height != 0 && newPhoto1.width != 0) {
      newPhoto1 = img.copyRotate(newPhoto1, angle: 90);
      newPhoto1 = img.copyResize(newPhoto1, width: imagesWidth, height: imagesHeight, maintainAspect: false);
    }
    if (newPhoto2.height != 0 && newPhoto2.width != 0) {
      newPhoto2 = img.copyRotate(newPhoto2, angle: 90);
      newPhoto2 = img.copyResize(newPhoto2, width: imagesWidth, height: imagesHeight, maintainAspect: false);
    }

    imagesToScan = [newPhoto1, newPhoto2, newPhoto0];
  }
}
