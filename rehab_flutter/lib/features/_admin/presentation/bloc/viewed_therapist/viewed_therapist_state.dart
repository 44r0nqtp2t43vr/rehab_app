import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';

abstract class ViewedTherapistState extends Equatable {
  final Therapist? therapist;
  final String? errorMessage;

  const ViewedTherapistState({this.therapist, this.errorMessage});

  @override
  List<Object> get props => [therapist!];
}

class ViewedTherapistNone extends ViewedTherapistState {
  const ViewedTherapistNone();
}

class ViewedTherapistLoading extends ViewedTherapistState {
  const ViewedTherapistLoading();
}

class ViewedTherapistDone extends ViewedTherapistState {
  const ViewedTherapistDone({String? errorMessage, Therapist? therapist}) : super(errorMessage: errorMessage, therapist: therapist);
}

class ViewedTherapistError extends ViewedTherapistState {
  const ViewedTherapistError({String? errorMessage, Therapist? therapist}) : super(errorMessage: errorMessage, therapist: therapist);
}
