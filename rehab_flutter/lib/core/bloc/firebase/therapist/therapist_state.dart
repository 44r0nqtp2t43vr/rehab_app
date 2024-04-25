import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';

abstract class TherapistState extends Equatable {
  final Therapist? currentTherapist;
  final String? errorMessage;
  final dynamic data;

  const TherapistState({this.currentTherapist, this.errorMessage, this.data});

  @override
  List<Object> get props => [currentTherapist!, errorMessage!, data!];
}

class TherapistNone extends TherapistState {
  const TherapistNone({String? errorMessage, dynamic data}) : super(errorMessage: errorMessage, data: data);
}

class TherapistLoading extends TherapistState {
  const TherapistLoading();
}

class TherapistDone extends TherapistState {
  const TherapistDone({Therapist? currentTherapist, dynamic data}) : super(currentTherapist: currentTherapist, data: data);
}
