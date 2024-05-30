import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

abstract class PatientCurrentPlanState extends Equatable {
  final Plan? currentPlan;
  final String? errorMessage;

  const PatientCurrentPlanState({this.currentPlan, this.errorMessage});

  @override
  List<Object> get props => [currentPlan!, errorMessage!];
}

class PatientCurrentPlanNone extends PatientCurrentPlanState {
  const PatientCurrentPlanNone();
}

class PatientCurrentPlanLoading extends PatientCurrentPlanState {
  const PatientCurrentPlanLoading();
}

class PatientCurrentPlanDone extends PatientCurrentPlanState {
  const PatientCurrentPlanDone({required Plan currentPlan}) : super(currentPlan: currentPlan);
}

class PatientCurrentPlanError extends PatientCurrentPlanState {
  const PatientCurrentPlanError({String? errorMessage}) : super(errorMessage: errorMessage);
}
