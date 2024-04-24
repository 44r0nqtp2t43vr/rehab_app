import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class PatientPlan {
  final AppUser patient;
  final Plan plan;

  PatientPlan({required this.patient, required this.plan});
}
