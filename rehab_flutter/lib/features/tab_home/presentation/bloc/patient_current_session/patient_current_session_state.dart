import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/session.dart';

abstract class PatientCurrentSessionState extends Equatable {
  final Session? currentSession;
  final String? errorMessage;

  const PatientCurrentSessionState({this.currentSession, this.errorMessage});

  @override
  List<Object> get props => [currentSession!, errorMessage!];
}

class PatientCurrentSessionNone extends PatientCurrentSessionState {
  const PatientCurrentSessionNone();
}

class PatientCurrentSessionLoading extends PatientCurrentSessionState {
  const PatientCurrentSessionLoading();
}

class PatientCurrentSessionDone extends PatientCurrentSessionState {
  const PatientCurrentSessionDone({required Session currentSession}) : super(currentSession: currentSession);
}

class PatientCurrentSessionError extends PatientCurrentSessionState {
  const PatientCurrentSessionError({String? errorMessage}) : super(errorMessage: errorMessage);
}
