import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';

abstract class ViewedTherapistPatientPlanEvent extends Equatable {
  final Plan? plan;
  final AppUser? patient;
  final EditSessionData? editSessionData;

  const ViewedTherapistPatientPlanEvent({this.plan, this.patient, this.editSessionData});

  @override
  List<Object> get props => [plan!, patient!, editSessionData!];
}

class EditTherapistPatientPlanSessionEvent extends ViewedTherapistPatientPlanEvent {
  const EditTherapistPatientPlanSessionEvent(EditSessionData editSessionData) : super(editSessionData: editSessionData);
}

class UpdateTherapistPatientPlanEvent extends ViewedTherapistPatientPlanEvent {
  const UpdateTherapistPatientPlanEvent(Plan plan, AppUser patient) : super(plan: plan, patient: patient);
}
