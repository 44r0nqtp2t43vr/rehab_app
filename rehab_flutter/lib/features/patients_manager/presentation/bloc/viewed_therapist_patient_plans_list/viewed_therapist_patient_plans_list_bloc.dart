import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_patient_plans_list.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_state.dart';

class ViewedTherapistPatientPlansListBloc extends Bloc<ViewedTherapistPatientPlansListEvent, ViewedTherapistPatientPlansListState> {
  final GetPatientPlansListUseCase _getPatientPlansListUseCase;

  ViewedTherapistPatientPlansListBloc(
    this._getPatientPlansListUseCase,
  ) : super(const ViewedTherapistPatientPlansListLoading()) {
    on<FetchViewedTherapistPatientPlansListEvent>(onFetchViewedTherapistPatientPlansList);
  }

  void onFetchViewedTherapistPatientPlansList(FetchViewedTherapistPatientPlansListEvent event, Emitter<ViewedTherapistPatientPlansListState> emit) async {
    emit(const ViewedTherapistPatientPlansListLoading());
    try {
      final List<Plan> plansList = await _getPatientPlansListUseCase(params: event.patientId!);
      emit(ViewedTherapistPatientPlansListDone(plansList: List.from(plansList)));
    } catch (e) {
      emit(ViewedTherapistPatientPlansListError(errorMessage: e.toString()));
    }
  }
}
