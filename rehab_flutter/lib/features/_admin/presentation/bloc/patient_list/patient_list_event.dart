import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientListEvent extends Equatable {
  final AppUser? patientToUpdate;

  const PatientListEvent({this.patientToUpdate});

  @override
  List<Object> get props => [patientToUpdate!];
}

class FetchPatientListEvent extends PatientListEvent {
  const FetchPatientListEvent() : super();
}

class UpdatePatientListEvent extends PatientListEvent {
  const UpdatePatientListEvent(AppUser patientToUpdate) : super(patientToUpdate: patientToUpdate);
}
