import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/add_plan.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_state.dart';

class ViewedPatientBloc extends Bloc<ViewedPatientEvent, ViewedPatientState> {
  final AddPlanUseCase _addPlanUseCase;

  ViewedPatientBloc(
    this._addPlanUseCase,
  ) : super(const ViewedPatientLoading()) {
    on<FetchViewedPatientEvent>(onFetchViewedPatient);
    on<AddPatientPlanEvent>(onAddPatientPlan);
  }

  void onFetchViewedPatient(FetchViewedPatientEvent event, Emitter<ViewedPatientState> emit) async {
    if (event.currentPatient != null) {
      emit(const ViewedPatientLoading());
      emit(ViewedPatientDone(patient: event.currentPatient));
    }
  }

  void onAddPatientPlan(AddPatientPlanEvent event, Emitter<ViewedPatientState> emit) async {
    emit(const ViewedPatientLoading());
    try {
      final currentUser = await _addPlanUseCase(params: event.addPlanData);
      emit(ViewedPatientDone(patient: currentUser));
    } catch (e) {
      emit(ViewedPatientDone(errorMessage: e.toString()));
    }
  }
}
