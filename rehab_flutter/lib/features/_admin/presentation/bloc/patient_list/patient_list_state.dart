import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class PatientListState extends Equatable {
  final List<AppUser> patientList;
  final String? errorMessage;

  const PatientListState({this.patientList = const [], this.errorMessage});

  @override
  List<Object> get props => [patientList];
}

class PatientListNone extends PatientListState {
  const PatientListNone();
}

class PatientListLoading extends PatientListState {
  const PatientListLoading({List<AppUser> patientList = const []}) : super(patientList: patientList);
}

class PatientListDone extends PatientListState {
  const PatientListDone({List<AppUser> patientList = const []}) : super(patientList: patientList);
}

class PatientListError extends PatientListState {
  const PatientListError({String? errorMessage}) : super(errorMessage: errorMessage);
}
