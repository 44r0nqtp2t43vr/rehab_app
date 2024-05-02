import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class TherapistPatientListEvent extends Equatable {
  final String? therapistId;
  final AppUser? patientToUpdate;

  const TherapistPatientListEvent({this.therapistId, this.patientToUpdate});

  @override
  List<Object> get props => [therapistId!, patientToUpdate!];
}

class FetchTherapistPatientListEvent extends TherapistPatientListEvent {
  const FetchTherapistPatientListEvent(String therapistId) : super(therapistId: therapistId);
}

class AddTherapistPatientListEvent extends TherapistPatientListEvent {
  const AddTherapistPatientListEvent(AppUser patientToUpdate) : super(patientToUpdate: patientToUpdate);
}

class RemoveTherapistPatientListEvent extends TherapistPatientListEvent {
  const RemoveTherapistPatientListEvent(AppUser patientToUpdate) : super(patientToUpdate: patientToUpdate);
}
