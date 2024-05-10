import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/usecases/firebase/add_plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/assign_patient.dart';
import 'package:rehab_flutter/core/usecases/firebase/delete_plan.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/therapist_patient_operations.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_state.dart';

class ViewedTherapistPatientBloc extends Bloc<ViewedTherapistPatientEvent, ViewedTherapistPatientState> {
  final AssignPatientUseCase _assignPatientUseCase;
  final AddPlanUseCase _addPlanUseCase;
  final DeletePlanUseCase _deletePlanUseCase;

  ViewedTherapistPatientBloc(
    this._assignPatientUseCase,
    this._addPlanUseCase,
    this._deletePlanUseCase,
  ) : super(const ViewedTherapistPatientLoading()) {
    on<ResetViewedTherapistPatientEvent>(onResetViewedTherapistPatientEvent);
    on<FetchViewedTherapistPatientEvent>(onFetchViewedTherapistPatient);
    on<AssignPatientEvent>(onAssignPatient);
    on<AddTherapistPatientPlanEvent>(onAddTherapistPatientPlan);
    on<DeleteTherapistPatientPlanEvent>(onDeleteTherapistPatientPlan);
    on<EditTherapistPatientSessionEvent>(onEditTherapistPatientSession);
    on<UpdateViewedTherapistPatientEvent>(onUpdateViewedTherapistPatientEvent);
  }

  void onResetViewedTherapistPatientEvent(ResetViewedTherapistPatientEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    emit(const ViewedTherapistPatientLoading());
  }

  void onFetchViewedTherapistPatient(FetchViewedTherapistPatientEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    if (event.currentPatient != null) {
      emit(const ViewedTherapistPatientLoading());
      emit(ViewedTherapistPatientDone(patient: event.currentPatient));
    }
  }

  void onAssignPatient(AssignPatientEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    emit(const ViewedTherapistPatientLoading());
    try {
      final updatedTherapist = await _assignPatientUseCase(params: event.assignData);
      emit(ViewedTherapistPatientDone(patient: event.currentPatient, therapist: updatedTherapist, operation: TherapistPatientOperation.unassign));
    } catch (e) {
      emit(ViewedTherapistPatientDone(errorMessage: e.toString(), patient: event.currentPatient, therapist: event.assignData!.therapist));
    }
  }

  void onAddTherapistPatientPlan(AddTherapistPatientPlanEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    emit(const ViewedTherapistPatientLoading());
    try {
      final currentUser = await _addPlanUseCase(params: event.addPlanData);
      emit(ViewedTherapistPatientDone(patient: currentUser, operation: TherapistPatientOperation.addPlan));
    } catch (e) {
      emit(ViewedTherapistPatientDone(errorMessage: e.toString()));
    }
  }

  void onDeleteTherapistPatientPlan(DeleteTherapistPatientPlanEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    emit(const ViewedTherapistPatientLoading());
    try {
      await _deletePlanUseCase(params: event.deletePlanData);
      AppUser updatedPatient = event.deletePlanData!.user;
      updatedPatient.plans.removeWhere((plan) => plan.planId == event.deletePlanData!.planIdToDelete);

      emit(ViewedTherapistPatientDone(patient: updatedPatient, operation: TherapistPatientOperation.deletePlan));
    } catch (e) {
      emit(ViewedTherapistPatientDone(errorMessage: e.toString()));
    }
  }

  void onEditTherapistPatientSession(EditTherapistPatientSessionEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    emit(const ViewedTherapistPatientLoading());
    try {
      final currentUser = await _addPlanUseCase(params: event.addPlanData);
      emit(ViewedTherapistPatientDone(patient: currentUser, operation: TherapistPatientOperation.editSession));
    } catch (e) {
      emit(ViewedTherapistPatientDone(errorMessage: e.toString()));
    }
  }

  void onUpdateViewedTherapistPatientEvent(UpdateViewedTherapistPatientEvent event, Emitter<ViewedTherapistPatientState> emit) async {
    emit(const ViewedTherapistPatientLoading());
    emit(ViewedTherapistPatientDone(patient: event.currentPatient));
  }
}
