import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

abstract class PatientPlansState extends Equatable {
  final List<Plan> plans;
  final String? errorMessage;

  const PatientPlansState({this.plans = const [], this.errorMessage});

  @override
  List<Object> get props => [plans, errorMessage!];
}

class PatientPlansNone extends PatientPlansState {
  const PatientPlansNone();
}

class PatientPlansLoading extends PatientPlansState {
  const PatientPlansLoading();
}

class PatientPlansDone extends PatientPlansState {
  const PatientPlansDone({required List<Plan> plans}) : super(plans: plans);
}

class PatientPlansError extends PatientPlansState {
  const PatientPlansError({String? errorMessage}) : super(errorMessage: errorMessage);
}
