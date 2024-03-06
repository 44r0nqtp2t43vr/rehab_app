import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_state.dart';
import 'package:rehab_flutter/core/usecases/connect_device.dart';
import 'package:rehab_flutter/core/usecases/disconnect_device.dart';
import 'package:rehab_flutter/core/usecases/scan_devices.dart';
import 'package:rehab_flutter/core/usecases/update_chara.dart';
import 'package:rehab_flutter/core/usecases/write_data.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothAppState> {
  final ScanDevicesUseCase _scanDevicesUseCase;
  final ConnectDeviceUseCase _connectDeviceUseCase;
  final DisconnectDeviceUseCase _disconnectDeviceUseCase;
  final UpdateCharaUseCase _updateCharaUseCase;
  final WriteDataUseCase _writeDataUseCase;

  BluetoothBloc(
    this._scanDevicesUseCase,
    this._connectDeviceUseCase,
    this._disconnectDeviceUseCase,
    this._updateCharaUseCase,
    this._writeDataUseCase,
  ) : super(const BluetoothLoading()) {
    on<ScanDevicesEvent>(onScanDevices);
    on<ConnectDeviceEvent>(onConnectDevice);
    on<DisconnectDeviceEvent>(onDisconnectDevice);
    on<UpdateCharaEvent>(onUpdateChara);
    on<WriteDataEvent>(onWriteData);
  }

  void onScanDevices(ScanDevicesEvent event, Emitter<BluetoothAppState> emit) async {
    final scanResults = await _scanDevicesUseCase();
    emit(BluetoothDone(scanResults: scanResults));
  }

  void onConnectDevice(ConnectDeviceEvent event, Emitter<BluetoothAppState> emit) async {
    final services = await _connectDeviceUseCase(params: event.targetDevice);
    emit(BluetoothDone(services: services));
  }

  void onDisconnectDevice(DisconnectDeviceEvent event, Emitter<BluetoothAppState> emit) async {
    await _disconnectDeviceUseCase();
    emit(const BluetoothDone());
  }

  void onUpdateChara(UpdateCharaEvent event, Emitter<BluetoothAppState> emit) async {
    await _updateCharaUseCase(params: event.targetCharacteristic);
    emit(const BluetoothDone());
  }

  void onWriteData(WriteDataEvent event, Emitter<BluetoothAppState> emit) async {
    await _writeDataUseCase(params: event.data);
    emit(const BluetoothDone());
  }
}
