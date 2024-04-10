import 'package:rehab_flutter/core/entities/user.dart';

class Physician {
  final String physicianId;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String city;
  final String licenseNumber;
  final DateTime birthDate;
  final DateTime registerDate;
  final List<AppUser> patients;

  Physician({
    required this.physicianId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.licenseNumber,
    required this.birthDate,
    required this.registerDate,
    required this.patients,
  });
}
