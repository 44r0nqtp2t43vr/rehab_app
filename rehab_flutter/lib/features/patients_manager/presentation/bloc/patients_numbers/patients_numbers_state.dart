import 'package:equatable/equatable.dart';

abstract class PatientNumbersState extends Equatable {
  final List<int> patientNumbers;
  final String? errorMessage;

  const PatientNumbersState({this.patientNumbers = const [], this.errorMessage});

  @override
  List<Object> get props => [patientNumbers];
}

class PatientNumbersNone extends PatientNumbersState {
  const PatientNumbersNone();
}

class PatientNumbersLoading extends PatientNumbersState {
  const PatientNumbersLoading();
}

class PatientNumbersDone extends PatientNumbersState {
  const PatientNumbersDone({List<int> patientNumbers = const []}) : super(patientNumbers: patientNumbers);
}

class PatientNumbersError extends PatientNumbersState {
  const PatientNumbersError({String? errorMessage}) : super(errorMessage: errorMessage);
}
