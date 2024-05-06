import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/edit_user_session.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan/viewed_therapist_patient_plan_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan/viewed_therapist_patient_plan_state.dart';

class ViewedTherapistPatientPlanBloc extends Bloc<ViewedTherapistPatientPlanEvent, ViewedTherapistPatientPlanState> {
  final EditUserSessionUseCase _editUserSessionUseCase;

  ViewedTherapistPatientPlanBloc(
    this._editUserSessionUseCase,
  ) : super(const ViewedTherapistPatientPlanLoading()) {
    on<EditTherapistPatientPlanSessionEvent>(onEditTherapistPatientSession);
    on<UpdateTherapistPatientPlanEvent>(onUpdateTherapistPatientPlanSession);
  }

  void onEditTherapistPatientSession(EditTherapistPatientPlanSessionEvent event, Emitter<ViewedTherapistPatientPlanState> emit) async {
    emit(const ViewedTherapistPatientPlanLoading());
    try {
      final currentUser = await _editUserSessionUseCase(params: event.editSessionData);
      emit(ViewedTherapistPatientPlanDone(plan: currentUser.plans.firstWhere((plan) => plan.planId == event.editSessionData!.planId), data: currentUser));
    } catch (e) {
      emit(ViewedTherapistPatientPlanError(errorMessage: e.toString()));
    }
  }

  void onUpdateTherapistPatientPlanSession(UpdateTherapistPatientPlanEvent event, Emitter<ViewedTherapistPatientPlanState> emit) async {
    emit(const ViewedTherapistPatientPlanLoading());
    emit(ViewedTherapistPatientPlanDone(plan: event.plan, data: event.patient));
  }
}
