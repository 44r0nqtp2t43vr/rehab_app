import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';

abstract class TherapistListEvent extends Equatable {
  final Therapist? therapistToUpdate;

  const TherapistListEvent({this.therapistToUpdate});

  @override
  List<Object> get props => [therapistToUpdate!];
}

class FetchTherapistListEvent extends TherapistListEvent {
  const FetchTherapistListEvent() : super();
}

class UpdateTherapistListEvent extends TherapistListEvent {
  const UpdateTherapistListEvent(Therapist therapistToUpdate) : super(therapistToUpdate: therapistToUpdate);
}
