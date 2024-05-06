import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

abstract class ViewedTherapistPatientPlanState extends Equatable {
  final Plan? plan;
  final String? errorMessage;
  final dynamic data;

  const ViewedTherapistPatientPlanState({this.plan, this.errorMessage, this.data});

  @override
  List<Object> get props => [plan!, data];
}

class ViewedTherapistPatientPlanNone extends ViewedTherapistPatientPlanState {
  const ViewedTherapistPatientPlanNone();
}

class ViewedTherapistPatientPlanLoading extends ViewedTherapistPatientPlanState {
  const ViewedTherapistPatientPlanLoading();
}

class ViewedTherapistPatientPlanDone extends ViewedTherapistPatientPlanState {
  const ViewedTherapistPatientPlanDone({Plan? plan, dynamic data}) : super(plan: plan, data: data);
}

class ViewedTherapistPatientPlanError extends ViewedTherapistPatientPlanState {
  const ViewedTherapistPatientPlanError({String? errorMessage}) : super(errorMessage: errorMessage);
}
