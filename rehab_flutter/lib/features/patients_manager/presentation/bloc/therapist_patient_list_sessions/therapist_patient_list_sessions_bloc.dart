import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/patient_sessions.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_therapist_patient_list_sessions.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patient_list_sessions/therapist_patient_list_sessions_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patient_list_sessions/therapist_patient_list_sessions_state.dart';

class TherapistPatientListSessionsBloc extends Bloc<TherapistPatientListSessionsEvent, TherapistPatientListSessionsState> {
  final GetTherapistPatientListSessionsUseCase _getTherapistPatientListSessionsUseCase;

  TherapistPatientListSessionsBloc(
    this._getTherapistPatientListSessionsUseCase,
  ) : super(const TherapistPatientListSessionsLoading()) {
    on<FetchTherapistPatientListSessionsEvent>(onFetchTherapistPatientListSessions);
  }

  void onFetchTherapistPatientListSessions(FetchTherapistPatientListSessionsEvent event, Emitter<TherapistPatientListSessionsState> emit) async {
    emit(const TherapistPatientListSessionsLoading());
    try {
      final List<PatientSessions> patientSessions = await _getTherapistPatientListSessionsUseCase(params: event.patientIds);
      emit(TherapistPatientListSessionsDone(patientSessions: List.from(patientSessions)));
    } catch (e) {
      emit(TherapistPatientListSessionsError(errorMessage: e.toString()));
    }
  }
}
