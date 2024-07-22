import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';

abstract class ViewedTherapistPatientPlanSessionsListEvent extends Equatable {
  final Plan? plan;
  final AppUser? patient;
  final EditSessionData? editSessionData;

  const ViewedTherapistPatientPlanSessionsListEvent({this.plan, this.patient, this.editSessionData});

  @override
  List<Object> get props => [plan!, patient!, editSessionData!];
}

class FetchViewedTherapistPatientPlanSessionsListEvent extends ViewedTherapistPatientPlanSessionsListEvent {
  const FetchViewedTherapistPatientPlanSessionsListEvent(Plan plan, AppUser patient) : super(plan: plan, patient: patient);
}

class EditViewedTherapistPatientPlanSessionsListEvent extends ViewedTherapistPatientPlanSessionsListEvent {
  const EditViewedTherapistPatientPlanSessionsListEvent(EditSessionData editSessionData) : super(editSessionData: editSessionData);
}
