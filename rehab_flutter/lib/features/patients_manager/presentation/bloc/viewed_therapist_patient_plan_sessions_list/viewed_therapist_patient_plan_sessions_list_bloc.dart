import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/edit_user_session.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_patient_plan_sessions_list.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_state.dart';

class ViewedTherapistPatientPlanSessionsListBloc extends Bloc<ViewedTherapistPatientPlanSessionsListEvent, ViewedTherapistPatientPlanSessionsListState> {
  final GetPatientPlanSessionsListUseCase _getPatientPlanSessionsListUseCase;
  final EditUserSessionUseCase _editUserSessionUseCase;

  ViewedTherapistPatientPlanSessionsListBloc(
    this._getPatientPlanSessionsListUseCase,
    this._editUserSessionUseCase,
  ) : super(const ViewedTherapistPatientPlanSessionsListLoading()) {
    on<FetchViewedTherapistPatientPlanSessionsListEvent>(onFetchViewedTherapistPatientPlanSessionsList);
    on<EditViewedTherapistPatientPlanSessionsListEvent>(onEditViewedTherapistPatientPlanSessionsList);
  }

  void onFetchViewedTherapistPatientPlanSessionsList(FetchViewedTherapistPatientPlanSessionsListEvent event, Emitter<ViewedTherapistPatientPlanSessionsListState> emit) async {
    emit(const ViewedTherapistPatientPlanSessionsListLoading());
    try {
      final sessionsList = await _getPatientPlanSessionsListUseCase(params: PatientPlan(patient: event.patient!, plan: event.plan!));

      emit(ViewedTherapistPatientPlanSessionsListDone(sessionsList: List.from(sessionsList)));
    } catch (e) {
      emit(ViewedTherapistPatientPlanSessionsListError(errorMessage: e.toString()));
    }
  }

  void onEditViewedTherapistPatientPlanSessionsList(EditViewedTherapistPatientPlanSessionsListEvent event, Emitter<ViewedTherapistPatientPlanSessionsListState> emit) async {
    final currentList = state.sessionsList;
    final currentListIndToEdit = currentList.indexWhere(
      (element) => element.sessionId == event.editSessionData!.sessionId,
    );
    final sessionToEdit = currentList[currentListIndToEdit];

    emit(const ViewedTherapistPatientPlanSessionsListLoading());
    try {
      await _editUserSessionUseCase(params: event.editSessionData);

      // sessionToEdit.standardOneType = event.editSessionData!.standardOneType;
      // sessionToEdit.standardOneIntensity = event.editSessionData!.standardOneIntensity;
      // sessionToEdit.standardTwoType = event.editSessionData!.standardTwoType;
      // sessionToEdit.standardTwoIntensity = event.editSessionData!.standardTwoIntensity;
      // sessionToEdit.passiveIntensity = event.editSessionData!.passiveIntensity;
      currentList[currentListIndToEdit] = sessionToEdit;

      emit(ViewedTherapistPatientPlanSessionsListDone(sessionsList: List.from(currentList)));
    } catch (e) {
      emit(ViewedTherapistPatientPlanSessionsListError(errorMessage: e.toString()));
    }
  }
}
