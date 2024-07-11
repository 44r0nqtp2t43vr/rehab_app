import 'package:equatable/equatable.dart';

abstract class ViewedTherapistPatientPlansListEvent extends Equatable {
  final String? patientId;

  const ViewedTherapistPatientPlansListEvent({this.patientId});

  @override
  List<Object> get props => [patientId!];
}

class FetchViewedTherapistPatientPlansListEvent extends ViewedTherapistPatientPlansListEvent {
  const FetchViewedTherapistPatientPlansListEvent(String patientId) : super(patientId: patientId);
}
