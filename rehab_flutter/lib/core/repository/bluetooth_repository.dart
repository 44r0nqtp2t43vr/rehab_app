import 'package:flutter_blue/flutter_blue.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';

class BluetoothRepository {
  final BluetoothController _controller;

  BluetoothRepository(this._controller);

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

  Future<void> updateCharacteristic(
      BluetoothCharacteristic targetCharacteristic) {
    _controller.updateCharacteristic(targetCharacteristic);
    return Future.value(null);
  }

  Future<void> writeData(String data) async {
    await _controller.writeData(data);
  }
}
