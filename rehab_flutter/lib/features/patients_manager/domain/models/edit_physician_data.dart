import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/entities/physician.dart';

class EditPhysicianData {
  final Physician user;
  final File? image;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;
  final String phoneNumber;
  final String licenseNumber;
  final String city;

  EditPhysicianData({
    required this.user,
    this.image,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'licenseNumber': licenseNumber,
      'city': city,
      'birthDate': Timestamp.fromDate(DateTime.utc(birthDate.year, birthDate.month, birthDate.day)),
    };
  }
}
