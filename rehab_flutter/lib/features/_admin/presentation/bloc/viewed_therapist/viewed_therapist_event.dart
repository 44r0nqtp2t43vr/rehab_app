import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';

abstract class ViewedTherapistEvent extends Equatable {
  final Therapist? currentTherapist;
  final AssignPatientData? assignData;

  const ViewedTherapistEvent({this.currentTherapist, this.assignData});

  @override
  List<Object> get props => [currentTherapist!, assignData!];
}

class FetchViewedTherapistEvent extends ViewedTherapistEvent {
  const FetchViewedTherapistEvent(Therapist currentTherapist) : super(currentTherapist: currentTherapist);
}

class AssignViewedTherapistEvent extends ViewedTherapistEvent {
  const AssignViewedTherapistEvent(AssignPatientData assignData) : super(assignData: assignData);
}
