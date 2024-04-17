import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class Admin {
  final List<AppUser> patients;
  final List<Physician> physicians;

  Admin({
    required this.patients,
    required this.physicians,
  });
}
