import 'package:rehab_flutter/core/entities/therapist.dart';

class AssignPatientData {
  final Therapist therapist;
  final String patientId;
  final bool isAssign;

  AssignPatientData({
    required this.therapist,
    required this.patientId,
    this.isAssign = true,
  });
}
