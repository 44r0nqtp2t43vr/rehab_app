import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothController _controller;

  BluetoothRepositoryImpl(this._controller);

  // Future<Stream<List<ScanResult>>> getScanResults() async {
  //   final scanResults = await _controller.scanDevices();
  //   return scanResults;
  // }

  // Future<List<BluetoothService>> getServices() async {
  //   final services = await _controller.discoverServices();
  //   return services;
  // }

  // Future<void> connectToDevice(BluetoothDevice targetDevice) async {
  //   await _controller.connectToDevice(targetDevice);
  // }

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
