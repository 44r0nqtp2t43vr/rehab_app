import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';

abstract class ViewedTherapistPatientEvent extends Equatable {
  final AppUser? currentPatient;
  final AssignPatientData? assignData;

  const ViewedTherapistPatientEvent({this.currentPatient, this.assignData});

  @override
  List<Object> get props => [currentPatient!];
}

class FetchViewedTherapistPatientEvent extends ViewedTherapistPatientEvent {
  const FetchViewedTherapistPatientEvent(AppUser currentPatient) : super(currentPatient: currentPatient);
}

class AssignPatientEvent extends ViewedTherapistPatientEvent {
  const AssignPatientEvent(AssignPatientData assignData, AppUser currentPatient) : super(assignData: assignData, currentPatient: currentPatient);
}
