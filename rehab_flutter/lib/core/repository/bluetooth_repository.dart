import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/resources/data_state.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothController _controller;

  BluetoothRepositoryImpl(this._controller);

  @override
  Future<DataState<List<BluetoothDevice>>> scanDevices() async {
    await _controller.startScan();
    return DataSuccess(_controller.filterDevicesList());
  }

  @override
  Future<void> updateCharacteristic(BluetoothCharacteristic targetCharacteristic) {
    _controller.updateCharacteristic(targetCharacteristic);
    return Future.value(null);
  }

  @override
  Future<void> writeData(String data) async {
    await _controller.writeData(data);
  }
}
