import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class Therapist {
  final String therapistId;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String city;
  final String licenseNumber;
  final DateTime birthDate;
  final DateTime registerDate;
  final List<String> patientsIds;
  final List<AppUser> patients;
  final String? imageURL;

  Therapist({
    required this.therapistId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.licenseNumber,
    required this.birthDate,
    required this.registerDate,
    required this.patientsIds,
    required this.patients,
    this.imageURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': therapistId,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'licenseNumber': licenseNumber,
      'birthDate': Timestamp.fromDate(DateTime.utc(birthDate.year, birthDate.month, birthDate.day)),
      'registerDate': Timestamp.fromDate(registerDate),
    };
  }

  String getUserFullName() {
    return "${firstName.capitalize!} ${lastName.capitalize!}";
  }
}
