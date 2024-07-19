import 'package:equatable/equatable.dart';

abstract class PatientNumbersEvent extends Equatable {
  final List<String> patientIds;

  const PatientNumbersEvent({this.patientIds = const []});

  @override
  List<Object> get props => [patientIds];
}

class FetchPatientNumbersEvent extends PatientNumbersEvent {
  const FetchPatientNumbersEvent(List<String> patientIds) : super(patientIds: patientIds);
}
