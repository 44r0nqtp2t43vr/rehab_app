import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientCurrentPlanEvent extends Equatable {
  final AppUser? patient;
  final Plan? currentPlan;
  final Session? currentSession;

  const PatientCurrentPlanEvent({this.patient, this.currentPlan, this.currentSession});

  @override
  List<Object> get props => [patient!, currentPlan!, currentSession!];
}

class FetchPatientCurrentPlanEvent extends PatientCurrentPlanEvent {
  const FetchPatientCurrentPlanEvent(AppUser patient) : super(patient: patient);
}

class UpdateCurrentPlanSessionEvent extends PatientCurrentPlanEvent {
  const UpdateCurrentPlanSessionEvent(Plan currentPlan, Session currentSession) : super(currentPlan: currentPlan, currentSession: currentSession);
}
