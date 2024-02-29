import 'package:rehab_flutter/core/enums/actuators_enums.dart';

class ActuatorsInitData {
  final ActuatorsOrientation orientation;
  final ActuatorsNumOfFingers numOfFingers;
  final String imgSrc;
  final int photosHeight;
  final int photosWidth;

  ActuatorsInitData({required this.orientation, required this.numOfFingers, required this.imgSrc, required this.photosHeight, required this.photosWidth});
}
