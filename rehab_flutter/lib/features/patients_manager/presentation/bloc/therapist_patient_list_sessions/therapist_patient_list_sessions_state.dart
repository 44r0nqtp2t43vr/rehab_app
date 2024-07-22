import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/patient_sessions.dart';

abstract class TherapistPatientListSessionsState extends Equatable {
  final List<PatientSessions> patientSessions;
  final String? errorMessage;

  const TherapistPatientListSessionsState({this.patientSessions = const [], this.errorMessage});

  @override
  List<Object> get props => [patientSessions];
}

class TherapistPatientListSessionsNone extends TherapistPatientListSessionsState {
  const TherapistPatientListSessionsNone();
}

class TherapistPatientListSessionsLoading extends TherapistPatientListSessionsState {
  const TherapistPatientListSessionsLoading();
}

class TherapistPatientListSessionsDone extends TherapistPatientListSessionsState {
  const TherapistPatientListSessionsDone({List<PatientSessions> patientSessions = const []}) : super(patientSessions: patientSessions);
}

class TherapistPatientListSessionsError extends TherapistPatientListSessionsState {
  const TherapistPatientListSessionsError({String? errorMessage}) : super(errorMessage: errorMessage);
}
