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

  Plan? getCurrentPlan() {
    final DateTime today = DateTime.now();
    final Plan currentPlan = plans.lastWhere(
      (plan) => plan.endDate.isAfter(today),
      orElse: () => Plan.empty(),
    );
    return currentPlan == Plan.empty() ? null : currentPlan;
  }

  String getUserUid() {
    return userId;
  }

  Session? getCurrentSession() {
    final DateTime today = DateTime.now();
    final Plan? currentPlan = getCurrentPlan();
    if (currentPlan == null) {
      return null;
    } else {
      final Session currentSession = currentPlan.sessions.firstWhere(
        (session) =>
            session.date.year == today.year &&
            session.date.month == today.month &&
            session.date.day == today.day,
        orElse: () => Session.empty(),
      );
      return currentSession == Session.empty() ? null : currentSession;
    }
  }

  List<Session> getAllSessionsFromAllPlans() {
    return plans.expand((plan) => plan.sessions).toList();
  }
}
