import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/usecases/firebase/add_plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/delete_plan.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_state.dart';

class ViewedPatientBloc extends Bloc<ViewedPatientEvent, ViewedPatientState> {
  final AddPlanUseCase _addPlanUseCase;
  final DeletePlanUseCase _deletePlanUseCase;

  ViewedPatientBloc(
    this._addPlanUseCase,
    this._deletePlanUseCase,
  ) : super(const ViewedPatientLoading()) {
    on<FetchViewedPatientEvent>(onFetchViewedPatient);
    on<AddPatientPlanEvent>(onAddPatientPlan);
    on<DeletePatientPlanEvent>(onDeletePatientPlan);
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

  void onDeletePatientPlan(DeletePatientPlanEvent event, Emitter<ViewedPatientState> emit) async {
    emit(const ViewedPatientLoading());
    try {
      await _deletePlanUseCase(params: event.deletePlanData);
      AppUser updatedPatient = event.deletePlanData!.user;

      emit(ViewedPatientDone(patient: updatedPatient));
    } catch (e) {
      emit(ViewedPatientDone(errorMessage: e.toString()));
    }
  }
}
