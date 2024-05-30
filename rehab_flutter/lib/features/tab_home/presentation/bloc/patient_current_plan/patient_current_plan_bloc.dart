import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/fetch_patient_current_plan.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_state.dart';

class PatientCurrentPlanBloc extends Bloc<PatientCurrentPlanEvent, PatientCurrentPlanState> {
  final FetchPatientCurrentPlanUseCase _fetchPatientCurrentPlanUseCase;

  PatientCurrentPlanBloc(
    this._fetchPatientCurrentPlanUseCase,
  ) : super(const PatientCurrentPlanLoading()) {
    on<FetchPatientCurrentPlanEvent>(onFetchPatientCurrentPlan);
  }

  void onFetchPatientCurrentPlan(FetchPatientCurrentPlanEvent event, Emitter<PatientCurrentPlanState> emit) async {
    try {
      final patientCurrentPlan = await _fetchPatientCurrentPlanUseCase(params: event.patient!.userId);

      emit(PatientCurrentPlanDone(currentPlan: patientCurrentPlan));
    } catch (e) {
      emit(PatientCurrentPlanError(errorMessage: e.toString()));
    }
  }
}
