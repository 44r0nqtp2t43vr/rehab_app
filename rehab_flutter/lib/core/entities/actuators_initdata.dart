import 'package:rehab_flutter/core/enums/actuators_enums.dart';

class ActuatorsInitData {
  final ActuatorsOrientation orientation;
  final ActuatorsNumOfFingers numOfFingers;
  final String imgSrc;
  final int imagesHeight;
  final int imagesWidth;

  ActuatorsInitData({required this.orientation, required this.numOfFingers, required this.imgSrc, required this.imagesHeight, required this.imagesWidth});
}
