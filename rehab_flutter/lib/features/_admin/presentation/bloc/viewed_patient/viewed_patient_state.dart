import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class ViewedPatientState extends Equatable {
  final AppUser? patient;
  final String? errorMessage;

  const ViewedPatientState({this.patient, this.errorMessage});

  @override
  List<Object> get props => [patient!];
}

class ViewedPatientNone extends ViewedPatientState {
  const ViewedPatientNone();
}

class ViewedPatientLoading extends ViewedPatientState {
  const ViewedPatientLoading();
}

class ViewedPatientDone extends ViewedPatientState {
  const ViewedPatientDone({String? errorMessage, AppUser? patient}) : super(errorMessage: errorMessage, patient: patient);
}

class ViewedPatientError extends ViewedPatientState {
  const ViewedPatientError({String? errorMessage, AppUser? patient}) : super(errorMessage: errorMessage, patient: patient);
}
