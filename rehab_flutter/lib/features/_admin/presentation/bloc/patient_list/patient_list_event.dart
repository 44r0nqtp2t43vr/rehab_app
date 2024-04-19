import 'package:equatable/equatable.dart';

abstract class PatientListEvent extends Equatable {
  const PatientListEvent();

  @override
  List<Object> get props => [];
}

class FetchPatientListEvent extends PatientListEvent {
  const FetchPatientListEvent() : super();
}
