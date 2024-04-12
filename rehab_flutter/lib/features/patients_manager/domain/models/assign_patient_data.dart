import 'package:rehab_flutter/core/entities/physician.dart';

class AssignPatientData {
  final Physician physician;
  final String patientId;
  final bool isAssign;

  AssignPatientData({
    required this.physician,
    required this.patientId,
    this.isAssign = true,
  });
}
