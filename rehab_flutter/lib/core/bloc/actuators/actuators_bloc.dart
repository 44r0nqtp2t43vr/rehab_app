import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/usecases/init_actuators.dart';
import 'package:rehab_flutter/core/usecases/update_actuators.dart';

class ActuatorsBloc extends Bloc<ActuatorsEvent, ActuatorsState> {
  final InitActuatorsUseCase _initActuatorsUseCase;
  final UpdateActuatorsUseCase _updateActuatorsUseCase;

  ActuatorsBloc(
    this._initActuatorsUseCase,
    this._updateActuatorsUseCase,
  ) : super(const ActuatorsLoading()) {
    on<InitActuatorsEvent>(onInitActuators);
    on<UpdateActuatorsEvent>(onUpdateActuators);
  }

  void onInitActuators(InitActuatorsEvent event, Emitter<ActuatorsState> emit) async {
    await _initActuatorsUseCase(params: event.initData);
    emit(const ActuatorsDone());
  }

  void onUpdateActuators(UpdateActuatorsEvent event, Emitter<ActuatorsState> emit) async {
    await _updateActuatorsUseCase(params: event.offset);
    emit(const ActuatorsDone());
  }
}
