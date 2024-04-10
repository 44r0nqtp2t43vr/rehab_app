import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_physician.dart';

class PhysicianBloc extends Bloc<PhysicianEvent, PhysicianState> {
  final RegisterPhysicianUseCase _registerPhysicianUseCase;

  PhysicianBloc(
    this._registerPhysicianUseCase,
  ) : super(const PhysicianNone()) {
    on<ResetPhysicianEvent>(onResetPhysician);
    on<RegisterPhysicianEvent>(onRegisterPhysician);
  }

  void onResetPhysician(ResetPhysicianEvent event, Emitter<PhysicianState> emit) {
    emit(const PhysicianNone());
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
}
