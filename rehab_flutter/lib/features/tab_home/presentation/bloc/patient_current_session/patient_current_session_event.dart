import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientCurrentSessionEvent extends Equatable {
  final AppUser? patient;

  const PatientCurrentSessionEvent({this.patient});

  @override
  List<Object> get props => [patient!];
}

class FetchPatientCurrentSessionEvent extends PatientCurrentSessionEvent {
  const FetchPatientCurrentSessionEvent(AppUser patient) : super(patient: patient);
}
