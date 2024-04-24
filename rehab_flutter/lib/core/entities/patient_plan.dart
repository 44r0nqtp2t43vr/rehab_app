import 'package:rehab_flutter/core/entities/plan.dart';

class PatientPlan {
  final String patientId;
  final Plan plan;

  PatientPlan({required this.patientId, required this.plan});
}
