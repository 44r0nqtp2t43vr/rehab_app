import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/fetch_patient_plans.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_event.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_state.dart';

class PatientPlansBloc extends Bloc<PatientPlansEvent, PatientPlansState> {
  final FetchPatientPlansUseCase _fetchPatientPlansUseCase;

  PatientPlansBloc(
    this._fetchPatientPlansUseCase,
  ) : super(const PatientPlansLoading()) {
    on<FetchPatientPlansEvent>(onFetchPatientPlans);
  }

  void onFetchPatientPlans(FetchPatientPlansEvent event, Emitter<PatientPlansState> emit) async {
    try {
      final patientPlans = await _fetchPatientPlansUseCase(params: event.patient!.userId);

      emit(PatientPlansDone(plans: patientPlans));
    } catch (e) {
      emit(PatientPlansError(errorMessage: e.toString()));
    }
  }
}
