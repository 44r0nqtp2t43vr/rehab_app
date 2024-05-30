import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientCurrentPlanEvent extends Equatable {
  final AppUser? patient;

  const PatientCurrentPlanEvent({this.patient});

  @override
  List<Object> get props => [patient!];
}

class FetchPatientCurrentPlanEvent extends PatientCurrentPlanEvent {
  const FetchPatientCurrentPlanEvent(AppUser patient) : super(patient: patient);
}
