import 'package:rehab_flutter/core/entities/user.dart';

class Physician {
  final String physicianId;
  final List<AppUser> patients;

  Physician({
    required this.physicianId,
    required this.patients,
  });
}
