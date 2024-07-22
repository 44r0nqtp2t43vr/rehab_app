import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class PatientSessions {
  final AppUser patient;
  final List<Session> sessions;

  PatientSessions({required this.patient, required this.sessions});
}
