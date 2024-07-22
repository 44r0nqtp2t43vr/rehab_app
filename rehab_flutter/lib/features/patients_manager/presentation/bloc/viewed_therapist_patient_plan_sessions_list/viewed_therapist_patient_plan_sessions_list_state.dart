import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/session.dart';

abstract class ViewedTherapistPatientPlanSessionsListState extends Equatable {
  final List<Session> sessionsList;
  final String? errorMessage;

  const ViewedTherapistPatientPlanSessionsListState({this.sessionsList = const [], this.errorMessage});

  @override
  List<Object> get props => [sessionsList];
}

class ViewedTherapistPatientPlanSessionsListNone extends ViewedTherapistPatientPlanSessionsListState {
  const ViewedTherapistPatientPlanSessionsListNone();
}

class ViewedTherapistPatientPlanSessionsListLoading extends ViewedTherapistPatientPlanSessionsListState {
  const ViewedTherapistPatientPlanSessionsListLoading();
}

class ViewedTherapistPatientPlanSessionsListDone extends ViewedTherapistPatientPlanSessionsListState {
  const ViewedTherapistPatientPlanSessionsListDone({List<Session> sessionsList = const []}) : super(sessionsList: sessionsList);
}

class ViewedTherapistPatientPlanSessionsListError extends ViewedTherapistPatientPlanSessionsListState {
  const ViewedTherapistPatientPlanSessionsListError({String? errorMessage}) : super(errorMessage: errorMessage);
}
