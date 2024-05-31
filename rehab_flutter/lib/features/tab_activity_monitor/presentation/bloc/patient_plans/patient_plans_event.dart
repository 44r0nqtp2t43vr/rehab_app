import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientPlansEvent extends Equatable {
  final AppUser? patient;
  final List<Plan>? patientPlans;
  final Session? currentSession;

  const PatientPlansEvent({this.patient, this.patientPlans, this.currentSession});

  @override
  List<Object> get props => [patient!, patientPlans!, currentSession!];
}

class FetchPatientPlansEvent extends PatientPlansEvent {
  const FetchPatientPlansEvent(AppUser patient) : super(patient: patient);
}

class UpdatePatientPlansEvent extends PatientPlansEvent {
  const UpdatePatientPlansEvent(List<Plan> patientPlans, Session currentSession) : super(patientPlans: patientPlans, currentSession: currentSession);
}
