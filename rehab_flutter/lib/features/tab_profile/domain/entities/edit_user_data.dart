import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class EditUserData {
  final AppUser user;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;
  final String phoneNumber;
  final String city;
  final List<String> conditions;

  EditUserData({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.city,
    required this.conditions,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'city': city,
      'birthDate': Timestamp.fromDate(DateTime.utc(birthDate.year, birthDate.month, birthDate.day)),
      'conditions': conditions,
    };
  }
}
