import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientPlansEvent extends Equatable {
  final AppUser? patient;

  const PatientPlansEvent({this.patient});

  @override
  List<Object> get props => [patient!];
}

class FetchPatientPlansEvent extends PatientPlansEvent {
  const FetchPatientPlansEvent(AppUser patient) : super(patient: patient);
}
