import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_state.dart';
import 'package:rehab_flutter/core/resources/data_state.dart';
import 'package:rehab_flutter/core/usecases/scan_devices.dart';
import 'package:rehab_flutter/core/usecases/update_chara.dart';
import 'package:rehab_flutter/core/usecases/write_data.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final ScanDevicesUseCase _scanDevicesUseCase;
  final UpdateCharaUseCase _updateCharaUseCase;
  final WriteDataUseCase _writeDataUseCase;

  BluetoothBloc(
    this._scanDevicesUseCase,
    this._updateCharaUseCase,
    this._writeDataUseCase,
  ) : super(const BluetoothLoading()) {
    on<ScanDevicesEvent>(onScanDevices);
    on<UpdateCharaEvent>(onUpdateChara);
    on<WriteDataEvent>(onWriteData);
  }

  void onScanDevices(ScanDevicesEvent event, Emitter<BluetoothState> emit) async {
    final dataState = await _scanDevicesUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(BluetoothDone(devices: dataState.data));
    } else {
      emit(const BluetoothNone());
    }
  }

  void onUpdateChara(UpdateCharaEvent event, Emitter<BluetoothState> emit) async {
    await _updateCharaUseCase(params: event.targetCharacteristic);
    emit(const BluetoothDone());
  }

  void onWriteData(WriteDataEvent event, Emitter<BluetoothState> emit) async {
    await _writeDataUseCase(params: event.data);
    emit(const BluetoothDone());
  }
}
