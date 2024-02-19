import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_state.dart';
import 'package:rehab_flutter/core/usecases/update_chara.dart';
import 'package:rehab_flutter/core/usecases/write_data.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  // final GetServicesUseCase _getServicesUseCase;
  final UpdateCharaUseCase _updateCharaUseCase;
  final WriteDataUseCase _writeDataUseCase;

  BluetoothBloc(
    // this._getServicesUseCase,
    this._updateCharaUseCase,
    this._writeDataUseCase,
  ) : super(const BluetoothLoading()) {
    // on<GetServices>(onGetServices);
    on<UpdateCharaEvent>(onUpdateChara);
    on<WriteDataEvent>(onWriteData);
  }

  // void onGetServices(
  //     GetServices event, Emitter<RemoteServiceState> emit) async {
  //   final data = await _getServicesUseCase(params: event.targetDevice);
  //   emit(RemoteServiceDone(services: data));
  // }

  void onUpdateChara(
      UpdateCharaEvent event, Emitter<BluetoothState> emit) async {
    await _updateCharaUseCase(params: event.targetCharacteristic);
    emit(const BluetoothDone());
  }

  void onWriteData(WriteDataEvent event, Emitter<BluetoothState> emit) async {
    await _writeDataUseCase(params: event.data);
    emit(const BluetoothDone());
  }
}
