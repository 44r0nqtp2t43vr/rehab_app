import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';

abstract class TherapistListState extends Equatable {
  final List<Therapist> therapistList;
  final String? errorMessage;

  const TherapistListState({this.therapistList = const [], this.errorMessage});

  @override
  List<Object> get props => [therapistList];
}

class TherapistListNone extends TherapistListState {
  const TherapistListNone();
}

class TherapistListLoading extends TherapistListState {
  const TherapistListLoading({List<Therapist> therapistList = const []}) : super(therapistList: therapistList);
}

class TherapistListDone extends TherapistListState {
  const TherapistListDone({List<Therapist> therapistList = const []}) : super(therapistList: therapistList);
}

class TherapistListError extends TherapistListState {
  const TherapistListError({String? errorMessage}) : super(errorMessage: errorMessage);
}
