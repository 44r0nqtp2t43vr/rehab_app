import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/fetch_patient_current_session.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_state.dart';

class PatientCurrentSessionBloc extends Bloc<PatientCurrentSessionEvent, PatientCurrentSessionState> {
  final FetchPatientCurrentSessionUseCase _fetchPatientCurrentSessionUseCase;

  PatientCurrentSessionBloc(
    this._fetchPatientCurrentSessionUseCase,
  ) : super(const PatientCurrentSessionLoading()) {
    on<FetchPatientCurrentSessionEvent>(onFetchPatientCurrentSession);
    on<UpdateCurrentSessionEvent>(onUpdateCurrentSession);
  }

  void onFetchPatientCurrentSession(FetchPatientCurrentSessionEvent event, Emitter<PatientCurrentSessionState> emit) async {
    emit(const PatientCurrentSessionLoading());
    try {
      final patientCurrentSession = await _fetchPatientCurrentSessionUseCase(params: event.patient!.userId);

      emit(PatientCurrentSessionDone(currentSession: patientCurrentSession));
    } catch (e) {
      emit(PatientCurrentSessionError(errorMessage: e.toString()));
    }
  }

  void onUpdateCurrentSession(UpdateCurrentSessionEvent event, Emitter<PatientCurrentSessionState> emit) async {
    emit(const PatientCurrentSessionLoading());
    emit(PatientCurrentSessionDone(currentSession: event.currentSession!));
  }
}
