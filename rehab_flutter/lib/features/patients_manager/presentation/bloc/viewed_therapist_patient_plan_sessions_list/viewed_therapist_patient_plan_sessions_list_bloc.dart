import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_patient_plan_sessions_list.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_state.dart';

class ViewedTherapistPatientPlanSessionsListBloc extends Bloc<ViewedTherapistPatientPlanSessionsListEvent, ViewedTherapistPatientPlanSessionsListState> {
  final GetPatientPlanSessionsListUseCase _getPatientPlanSessionsListUseCase;

  ViewedTherapistPatientPlanSessionsListBloc(
    this._getPatientPlanSessionsListUseCase,
  ) : super(const ViewedTherapistPatientPlanSessionsListLoading()) {
    on<FetchViewedTherapistPatientPlanSessionsListEvent>(onFetchViewedTherapistPatientPlanSessionsList);
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
}
