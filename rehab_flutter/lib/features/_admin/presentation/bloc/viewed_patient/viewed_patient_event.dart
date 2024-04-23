import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class ViewedPatientEvent extends Equatable {
  final AppUser? currentPatient;

  const ViewedPatientEvent({this.currentPatient});

  @override
  List<Object> get props => [currentPatient!];
}

class FetchViewedPatientEvent extends ViewedPatientEvent {
  const FetchViewedPatientEvent(AppUser currentPatient) : super(currentPatient: currentPatient);
}
