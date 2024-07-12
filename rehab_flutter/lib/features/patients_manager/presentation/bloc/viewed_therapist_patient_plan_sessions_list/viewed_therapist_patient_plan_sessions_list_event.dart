import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class ViewedTherapistPatientPlanSessionsListEvent extends Equatable {
  final Plan? plan;
  final AppUser? patient;

  const ViewedTherapistPatientPlanSessionsListEvent({this.plan, this.patient});

  @override
  List<Object> get props => [plan!, patient!];
}

class FetchViewedTherapistPatientPlanSessionsListEvent extends ViewedTherapistPatientPlanSessionsListEvent {
  const FetchViewedTherapistPatientPlanSessionsListEvent(Plan plan, AppUser patient) : super(plan: plan, patient: patient);
}
