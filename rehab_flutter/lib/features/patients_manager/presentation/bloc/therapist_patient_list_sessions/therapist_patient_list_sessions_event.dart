import 'package:equatable/equatable.dart';

abstract class TherapistPatientListSessionsEvent extends Equatable {
  final List<String> patientIds;

  const TherapistPatientListSessionsEvent({this.patientIds = const []});

  @override
  List<Object> get props => [patientIds];
}

class FetchTherapistPatientListSessionsEvent extends TherapistPatientListSessionsEvent {
  const FetchTherapistPatientListSessionsEvent(List<String> patientIds) : super(patientIds: patientIds);
}
