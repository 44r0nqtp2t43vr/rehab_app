import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class Admin {
  final List<AppUser> patients;
  final List<Therapist> therapists;

  Admin({
    required this.patients,
    required this.therapists,
  });
}
