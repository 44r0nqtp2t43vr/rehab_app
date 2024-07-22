import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

abstract class ViewedTherapistPatientPlansListState extends Equatable {
  final List<Plan> plansList;
  final String? errorMessage;

  const ViewedTherapistPatientPlansListState({this.plansList = const [], this.errorMessage});

  @override
  List<Object> get props => [plansList];
}

class ViewedTherapistPatientPlansListNone extends ViewedTherapistPatientPlansListState {
  const ViewedTherapistPatientPlansListNone();
}

class ViewedTherapistPatientPlansListLoading extends ViewedTherapistPatientPlansListState {
  const ViewedTherapistPatientPlansListLoading();
}

class ViewedTherapistPatientPlansListDone extends ViewedTherapistPatientPlansListState {
  const ViewedTherapistPatientPlansListDone({List<Plan> plansList = const []}) : super(plansList: plansList);
}

class ViewedTherapistPatientPlansListError extends ViewedTherapistPatientPlansListState {
  const ViewedTherapistPatientPlansListError({String? errorMessage}) : super(errorMessage: errorMessage);
}
