import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';

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

  String getUserUid() {
    return userId;
  }

  Plan? getCurrentPlan() {
    final DateTime today = DateTime.now();
    final Plan currentPlan = plans.lastWhere(
      (plan) => DateTime(plan.endDate.year, plan.endDate.month, plan.endDate.day).isAfter(today),
      orElse: () => Plan.empty(),
    );
    return currentPlan.planId.isEmpty ? null : currentPlan;
  }

  Session? getCurrentSession() {
    final DateTime today = DateTime.now();
    final Plan? currentPlan = getCurrentPlan();
    if (currentPlan == null) {
      return null;
    } else {
      final Session currentSession = currentPlan.sessions.firstWhere(
        (session) => session.date.year == today.year && session.date.month == today.month && session.date.day == today.day,
        orElse: () => Session.empty(),
      );
      return currentSession.sessionId.isEmpty ? null : currentSession;
    }
  }

  List<Session> getAllSessionsFromAllPlans() {
    return plans.expand((plan) => plan.sessions).toList();
  }

  Map<String, Color?> getDateColorsMap() {
    Map<String, Color?> dateColorsMap = {};
    List<Session> sessions = getAllSessionsFromAllPlans();

    for (var sesh in sessions) {
      final String dateString = "${sesh.date.year}${sesh.date.month}${sesh.date.day}";
      final List<bool> conditions = sesh.getSessionConditions();

      if (conditions[0] && conditions[1] && conditions[2] && conditions[3] && conditions[4]) {
        dateColorsMap[dateString] = const Color.fromRGBO(0, 128, 0, 1.0);
      } else if (conditions[0] && conditions[1] && conditions[2] && conditions[3]) {
        dateColorsMap[dateString] = const Color.fromRGBO(32, 160, 32, 1.0);
      } else if (conditions[0] && conditions[1] && conditions[2]) {
        dateColorsMap[dateString] = const Color.fromRGBO(64, 128, 64, 1.0);
      } else if (conditions[0] && conditions[1]) {
        dateColorsMap[dateString] = const Color.fromRGBO(96, 192, 96, 1.0);
      } else if (conditions[0]) {
        dateColorsMap[dateString] = const Color.fromRGBO(128, 255, 128, 1.0);
      } else {
        dateColorsMap[dateString] = null;
      }
    }

    return dateColorsMap;
  }
}
