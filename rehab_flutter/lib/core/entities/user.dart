import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

class AppUser {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String city;
  final DateTime birthDate;
  final List<String> conditions;
  final DateTime registerDate;
  final List<Plan> plans;

  const AppUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.birthDate,
    required this.conditions,
    required this.registerDate,
    this.plans = const [], // Default empty list if not provided
  });
}
