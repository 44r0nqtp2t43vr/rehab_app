import 'package:equatable/equatable.dart';

abstract class AdminPatientNumbersState extends Equatable {
  final List<int> patientNumbers;
  final String? errorMessage;

  const AdminPatientNumbersState({this.patientNumbers = const [], this.errorMessage});

  @override
  List<Object> get props => [patientNumbers];
}

class AdminPatientNumbersNone extends AdminPatientNumbersState {
  const AdminPatientNumbersNone();
}

class AdminPatientNumbersLoading extends AdminPatientNumbersState {
  const AdminPatientNumbersLoading();
}

class AdminPatientNumbersDone extends AdminPatientNumbersState {
  const AdminPatientNumbersDone({List<int> patientNumbers = const []}) : super(patientNumbers: patientNumbers);
}

class AdminPatientNumbersError extends AdminPatientNumbersState {
  const AdminPatientNumbersError({String? errorMessage}) : super(errorMessage: errorMessage);
}
