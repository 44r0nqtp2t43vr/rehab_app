import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class TherapistPatientListState extends Equatable {
  final List<AppUser> therapistPatientList;
  final String? errorMessage;

  const TherapistPatientListState({this.therapistPatientList = const [], this.errorMessage});

  @override
  List<Object> get props => [therapistPatientList];
}

class TherapistPatientListNone extends TherapistPatientListState {
  const TherapistPatientListNone();
}

class TherapistPatientListLoading extends TherapistPatientListState {
  const TherapistPatientListLoading({List<AppUser> therapistPatientList = const []}) : super(therapistPatientList: therapistPatientList);
}

class TherapistPatientListDone extends TherapistPatientListState {
  const TherapistPatientListDone({List<AppUser> therapistPatientList = const []}) : super(therapistPatientList: therapistPatientList);
}

class TherapistPatientListError extends TherapistPatientListState {
  const TherapistPatientListError({String? errorMessage}) : super(errorMessage: errorMessage);
}
