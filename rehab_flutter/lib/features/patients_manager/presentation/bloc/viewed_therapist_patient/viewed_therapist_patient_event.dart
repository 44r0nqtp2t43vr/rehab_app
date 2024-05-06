import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';

abstract class ViewedTherapistPatientEvent extends Equatable {
  final AppUser? currentPatient;
  final AssignPatientData? assignData;
  final AddPlanData? addPlanData;
  final EditSessionData? editSessionData;

  const ViewedTherapistPatientEvent({this.currentPatient, this.assignData, this.addPlanData, this.editSessionData});

  @override
  List<Object> get props => [currentPatient!];
}

class ResetViewedTherapistPatientEvent extends ViewedTherapistPatientEvent {
  const ResetViewedTherapistPatientEvent() : super();
}

class FetchViewedTherapistPatientEvent extends ViewedTherapistPatientEvent {
  const FetchViewedTherapistPatientEvent(AppUser currentPatient) : super(currentPatient: currentPatient);
}

class AssignPatientEvent extends ViewedTherapistPatientEvent {
  const AssignPatientEvent(AssignPatientData assignData, AppUser currentPatient) : super(assignData: assignData, currentPatient: currentPatient);
}

class AddTherapistPatientPlanEvent extends ViewedTherapistPatientEvent {
  const AddTherapistPatientPlanEvent(AddPlanData addPlanData) : super(addPlanData: addPlanData);
}

class EditTherapistPatientSessionEvent extends ViewedTherapistPatientEvent {
  const EditTherapistPatientSessionEvent(EditSessionData editSessionData) : super(editSessionData: editSessionData);
}

class UpdateViewedTherapistPatientEvent extends ViewedTherapistPatientEvent {
  const UpdateViewedTherapistPatientEvent(AppUser currentPatient) : super(currentPatient: currentPatient);
}
