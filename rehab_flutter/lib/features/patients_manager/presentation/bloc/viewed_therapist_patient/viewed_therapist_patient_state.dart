import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class ViewedTherapistPatientState extends Equatable {
  final Therapist? therapist;
  final AppUser? patient;
  final String? errorMessage;

  const ViewedTherapistPatientState({this.therapist, this.patient, this.errorMessage});

  @override
  List<Object> get props => [therapist!, patient!, errorMessage!];
}

class ViewedTherapistPatientNone extends ViewedTherapistPatientState {
  const ViewedTherapistPatientNone();
}

class ViewedTherapistPatientLoading extends ViewedTherapistPatientState {
  const ViewedTherapistPatientLoading();
}

class ViewedTherapistPatientDone extends ViewedTherapistPatientState {
  const ViewedTherapistPatientDone({
    String? errorMessage,
    AppUser? patient,
    Therapist? therapist,
  }) : super(
          errorMessage: errorMessage,
          patient: patient,
          therapist: therapist,
        );
}

class ViewedTherapistPatientError extends ViewedTherapistPatientState {
  const ViewedTherapistPatientError({
    String? errorMessage,
    AppUser? patient,
    Therapist? therapist,
  }) : super(
          errorMessage: errorMessage,
          patient: patient,
          therapist: therapist,
        );
}
