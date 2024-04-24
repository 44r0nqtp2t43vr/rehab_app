import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/assign_patient.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_state.dart';

class ViewedTherapistPatientBloc extends Bloc<ViewedTherapistPatientEvent, ViewedTherapistPatientState> {
  final AssignPatientUseCase _assignPatientUseCase;

  ViewedTherapistPatientBloc(
    this._assignPatientUseCase,
  ) : super(const ViewedTherapistPatientLoading()) {
    on<FetchViewedTherapistPatientEvent>(onFetchViewedTherapistPatient);
    on<AssignPatientEvent>(onAssignPatient);
  }

  void onFetchViewedTherapistPatient(FetchViewedTherapistPatientEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    if (event.currentPatient != null) {
      emit(ViewedTherapistPatientDone(patient: event.currentPatient));
    }
  }

  void onAssignPatient(AssignPatientEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    emit(const ViewedTherapistPatientLoading());
    try {
      final updatedTherapist = await _assignPatientUseCase(params: event.assignData);
      emit(ViewedTherapistPatientDone(patient: event.currentPatient, therapist: updatedTherapist));
    } catch (e) {
      emit(ViewedTherapistPatientDone(errorMessage: e.toString(), patient: event.currentPatient, therapist: event.assignData!.therapist));
    }
  }
}
