import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';

abstract class ViewedTherapistPatientEvent extends Equatable {
  final AppUser? currentPatient;
  final AssignPatientData? assignData;
  final AddPlanData? addPlanData;

  const ViewedTherapistPatientEvent({this.currentPatient, this.assignData, this.addPlanData});

  @override
  List<Object> get props => [currentPatient!];
}

class FetchViewedTherapistPatientEvent extends ViewedTherapistPatientEvent {
  const FetchViewedTherapistPatientEvent(AppUser currentPatient) : super(currentPatient: currentPatient);
}

class AssignPatientEvent extends ViewedTherapistPatientEvent {
  const AssignPatientEvent(AssignPatientData assignData, AppUser currentPatient) : super(assignData: assignData, currentPatient: currentPatient);
}

class AddPatientPlanEvent extends ViewedTherapistPatientEvent {
  const AddPatientPlanEvent(AddPlanData addPlanData) : super(addPlanData: addPlanData);
}
