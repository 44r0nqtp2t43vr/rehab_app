import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class TherapistPatientListEvent extends Equatable {
  final List<String>? therapistPatientsIds;
  final AppUser? patientToUpdate;

  const TherapistPatientListEvent({this.therapistPatientsIds, this.patientToUpdate});

  @override
  List<Object> get props => [therapistPatientsIds!, patientToUpdate!];
}

class FetchTherapistPatientListEvent extends TherapistPatientListEvent {
  const FetchTherapistPatientListEvent(List<String> therapistPatientsIds) : super(therapistPatientsIds: therapistPatientsIds);
}

class RemoveTherapistPatientListEvent extends TherapistPatientListEvent {
  const RemoveTherapistPatientListEvent(AppUser patientToUpdate) : super(patientToUpdate: patientToUpdate);
}
