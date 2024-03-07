import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothController _controller;

  BluetoothRepositoryImpl(this._controller);

  @override
  Future<Stream<List<ScanResult>>> scanDevices() async {
    final scanResults = await _controller.scanDevices();
    return scanResults;
  }

  @override
  Future<List<BluetoothService>> connectDevice(
      BluetoothDevice targetDevice) async {
    return await _controller
        .connectToDevice(targetDevice)
        .then((value) => _controller.discoverServices().then((value) => value));
  }

  @override
  Future<void> disconnectDevice() async {
    await _controller.disconnectDevice();
  }

  @override
  Future<void> updateCharacteristic(
      BluetoothCharacteristic targetCharacteristic) {
    _controller.updateCharacteristic(targetCharacteristic);
    return Future.value(null);
  }

  @override
  Future<void> writeData(String data) async {
    await _controller.writeData(data);
  }
}
