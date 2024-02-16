import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothController {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription? scanSubscription;
  List<BluetoothDevice> devicesList = [];

  void startScan(
      {required Function(List<BluetoothDevice>) onDevicesDiscovered}) {
    stopScan();
    devicesList.clear();

    scanSubscription?.cancel();
    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.any((device) => device.id == result.device.id)) {
          devicesList.add(result.device);
        }
      }
      onDevicesDiscovered(devicesList);
    });

    flutterBlue.startScan(timeout: Duration(seconds: 4));
  }

  void stopScan() {
    scanSubscription?.cancel();
    flutterBlue.stopScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
  }

  Future<List<BluetoothService>> discoverServices(
      BluetoothDevice device) async {
    return await device.discoverServices();
  }

  void sendPattern(BluetoothCharacteristic targetCharacteristic, String data) {
    targetCharacteristic.write(data.codeUnits);
  }

  void disconnectDevice(BluetoothDevice device) {
    device.disconnect();
  }
}
