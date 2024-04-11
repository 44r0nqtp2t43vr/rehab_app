import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/logout_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_physician.dart';

class PhysicianBloc extends Bloc<PhysicianEvent, PhysicianState> {
  final RegisterPhysicianUseCase _registerPhysicianUseCase;
  final LogoutUserUseCase _logoutUserUseCase;

  PhysicianBloc(
    this._registerPhysicianUseCase,
    this._logoutUserUseCase,
  ) : super(const PhysicianNone()) {
    on<ResetPhysicianEvent>(onResetPhysician);
    on<GetPhysicianEvent>(onGetPhysician);
    on<RegisterPhysicianEvent>(onRegisterPhysician);
    on<LogoutPhysicianEvent>(onLogoutPhysician);
  }

  void onResetPhysician(ResetPhysicianEvent event, Emitter<PhysicianState> emit) {
    emit(const PhysicianNone());
  }

  void onGetPhysician(GetPhysicianEvent event, Emitter<PhysicianState> emit) {
    emit(PhysicianDone(currentPhysician: event.currentPhysician));
  }

  void onRegisterPhysician(RegisterPhysicianEvent event, Emitter<PhysicianState> emit) async {
    emit(const PhysicianLoading());
    try {
      await _registerPhysicianUseCase(params: event.registerData);
      emit(const PhysicianDone(currentPhysician: null));
    } catch (e) {
      emit(PhysicianNone(errorMessage: e.toString()));
    }
  }

  void onLogoutPhysician(LogoutPhysicianEvent event, Emitter<PhysicianState> emit) async {
    emit(const PhysicianLoading());
    try {
      await _logoutUserUseCase();
      emit(const PhysicianNone());
    } catch (e) {
      emit(PhysicianDone(currentPhysician: event.currentPhysician));
    }
  }
}
