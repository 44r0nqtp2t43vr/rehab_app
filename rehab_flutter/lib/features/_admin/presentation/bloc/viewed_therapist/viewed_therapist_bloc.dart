import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/usecases/firebase/assign_patient.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_state.dart';

class ViewedTherapistBloc extends Bloc<ViewedTherapistEvent, ViewedTherapistState> {
  final AssignPatientUseCase _assignPatientUseCase;

  ViewedTherapistBloc(
    this._assignPatientUseCase,
  ) : super(const ViewedTherapistLoading()) {
    on<FetchViewedTherapistEvent>(onFetchViewedTherapist);
    on<AssignViewedTherapistEvent>(onAssignViewedTherapist);
  }

  void onFetchViewedTherapist(FetchViewedTherapistEvent event, Emitter<ViewedTherapistState> emit) async {
    if (event.currentTherapist != null) {
      emit(const ViewedTherapistLoading());
      emit(ViewedTherapistDone(therapist: event.currentTherapist));
    }
  }

  void onAssignViewedTherapist(AssignViewedTherapistEvent event, Emitter<ViewedTherapistState> emit) async {
    emit(const ViewedTherapistLoading());
    try {
      await _assignPatientUseCase(params: event.assignData);

      Therapist updatedTherapist = event.assignData!.therapist;

      if (event.assignData!.isAssign == true) {
        updatedTherapist.patientsIds.add(event.assignData!.patientId);
      } else {
        updatedTherapist.patientsIds.remove(event.assignData!.patientId);
      }

      emit(ViewedTherapistDone(therapist: updatedTherapist));
    } catch (e) {
      emit(ViewedTherapistDone(errorMessage: e.toString(), therapist: event.assignData!.therapist));
    }
  }
}
