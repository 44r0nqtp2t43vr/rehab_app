import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/assign_patient.dart';
import 'package:rehab_flutter/core/usecases/firebase/edit_therapist.dart';
import 'package:rehab_flutter/core/usecases/firebase/logout_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_therapist.dart';

class TherapistBloc extends Bloc<TherapistEvent, TherapistState> {
  final RegisterTherapistUseCase _registerTherapistUseCase;
  final AssignPatientUseCase _assignPatientUseCase;
  final EditTherapistUseCase _editTherapistUseCase;
  final LogoutUserUseCase _logoutUserUseCase;

  TherapistBloc(
    this._registerTherapistUseCase,
    this._assignPatientUseCase,
    this._editTherapistUseCase,
    this._logoutUserUseCase,
  ) : super(const TherapistNone()) {
    on<ResetTherapistEvent>(onResetTherapist);
    on<GetTherapistEvent>(onGetTherapist);
    on<RegisterTherapistEvent>(onRegisterTherapist);
    on<AssignPatientEvent>(onAssignPatient);
    on<EditTherapistEvent>(onEditTherapist);
    on<LogoutTherapistEvent>(onLogoutTherapist);
  }

  void onResetTherapist(ResetTherapistEvent event, Emitter<TherapistState> emit) {
    emit(const TherapistNone());
  }

  void onGetTherapist(GetTherapistEvent event, Emitter<TherapistState> emit) {
    emit(TherapistDone(currentTherapist: event.currentTherapist));
  }

  void onRegisterTherapist(RegisterTherapistEvent event, Emitter<TherapistState> emit) async {
    emit(const TherapistLoading());
    try {
      await _registerTherapistUseCase(params: event.registerData);
      emit(const TherapistDone(currentTherapist: null));
    } catch (e) {
      emit(TherapistNone(errorMessage: e.toString()));
    }
  }

  void onAssignPatient(AssignPatientEvent event, Emitter<TherapistState> emit) async {
    emit(const TherapistLoading());
    try {
      final updatedTherapist = await _assignPatientUseCase(params: event.assignData);
      emit(TherapistDone(currentTherapist: updatedTherapist));
    } catch (e) {
      emit(TherapistNone(errorMessage: e.toString(), data: event.assignData!.therapist));
    }
  }

  void onEditTherapist(EditTherapistEvent event, Emitter<TherapistState> emit) async {
    emit(const TherapistLoading());
    try {
      final updatedTherapist = await _editTherapistUseCase(params: event.editData);
      emit(TherapistDone(currentTherapist: updatedTherapist));
    } catch (e) {
      emit(TherapistNone(errorMessage: e.toString(), data: event.editData!.user));
    }
  }

  void onLogoutTherapist(LogoutTherapistEvent event, Emitter<TherapistState> emit) async {
    emit(const TherapistLoading());
    try {
      await _logoutUserUseCase();
      emit(const TherapistNone());
    } catch (e) {
      emit(TherapistDone(currentTherapist: event.currentTherapist));
    }
  }
}
