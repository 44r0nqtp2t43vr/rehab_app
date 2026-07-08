import 'package:rehab_flutter/core/entities/session.dart';

class Plan {
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final List<Session> sessions;

  Plan({
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.sessions,
  });

  static Plan empty() {
    return Plan(
      planId: '',
      planName: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      sessions: [],
    );
  }

  double getPlanPercentCompletion() {
    double percent = 0;
    if (sessions.isEmpty) {
      return percent;
    }

    for (var session in sessions) {
      percent += session.getSessionPercentCompletion();
    }
    return percent / sessions.length;
  }

  Session? getCurrentSession() {
    final DateTime today = DateTime.now();

    final Session currentSession = sessions.firstWhere(
      (session) => session.endDate.isAfter(today),
      orElse: () => Session.empty(),
    );
    return currentSession.sessionId.isEmpty ? null : currentSession;
  }

  int getIndexOfCurrentSession() {
    final DateTime today = DateTime.now();
    final int indexOfCurrentSession = sessions.indexWhere(
      (session) => session.endDate.isAfter(today),
    );
    return indexOfCurrentSession;
  }

  void setCurrentSession(Session newSession) {
    final indexOfCurrentSession = getIndexOfCurrentSession();

    sessions[indexOfCurrentSession] = newSession;
  }
}

// Plan Provider
// Weekly Plan
// startDate = DateTime.now
// endDate = startDate + 7 days
// sessions[7] = [Session1, Session2, Session3, Session4, Session5, Session6, Session7]
// Each session is determind by the pretest.
