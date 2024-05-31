import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientCurrentSessionEvent extends Equatable {
  final AppUser? patient;
  final Session? currentSession;

  const PatientCurrentSessionEvent({this.patient, this.currentSession});

  @override
  List<Object> get props => [patient!, currentSession!];
}

class FetchPatientCurrentSessionEvent extends PatientCurrentSessionEvent {
  const FetchPatientCurrentSessionEvent(AppUser patient) : super(patient: patient);
}

class UpdateCurrentSessionEvent extends PatientCurrentSessionEvent {
  const UpdateCurrentSessionEvent(Session currentSession) : super(currentSession: currentSession);
}
