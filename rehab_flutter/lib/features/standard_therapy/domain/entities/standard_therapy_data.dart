import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';

class StandardTherapyData {
  final String userId;
  final bool isStandardOne;
  final StandardTherapy type;
  final int intensity;

  StandardTherapyData({
    required this.userId,
    required this.isStandardOne,
    required this.type,
    required this.intensity,
  });
}
