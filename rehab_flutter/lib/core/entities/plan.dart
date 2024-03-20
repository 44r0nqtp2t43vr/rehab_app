import 'package:rehab_flutter/core/entities/session.dart';

class Plan {
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int sessionCount;
  final List<Session> sessions;

  Plan({
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.sessions,
    this.isActive = false,
    this.sessionCount = 0,
  });
}

// Plan Provider
// Weekly Plan
// startDate = DateTime.now
// endDate = startDate + 7 days
// sessions[7] = [Session1, Session2, Session3, Session4, Session5, Session6, Session7]
// Each session is determind by the pretest.
