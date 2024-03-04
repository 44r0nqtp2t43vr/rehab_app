import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BluetoothController extends GetxController {
  StreamSubscription? scanSubscription;
  List<BluetoothDevice> devicesList = [];

  late BluetoothDevice targetDevice;
  late BluetoothCharacteristic targetCharacteristic;

  Future<void> startScan() async {
    // Stop any ongoing scan
    FlutterBluePlus.stopScan();

    // Clear the device list
    devicesList.clear();

    // Cancel any existing scan subscription
    scanSubscription?.cancel();

    // Listen to scan results
    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.any((device) => device.remoteId == result.device.remoteId)) {
          devicesList.add(result.device);
        }
      }
    });

    // Start the scan
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 1));
  }

  void stopScan() {
    scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
  }

  List<BluetoothDevice> filterDevicesList() {
    return devicesList.where((device) => device.platformName.contains('Gloves')).toList();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
  }

  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async {
    return await device.discoverServices();
  }

  void sendPattern(BluetoothCharacteristic targetCharacteristic, String data) {
    targetCharacteristic.write(data.codeUnits);
  }

  void disconnectDevice() {
    targetDevice.disconnect();
  }

  void updateCharacteristic(BluetoothCharacteristic newCharacteristic) {
    targetCharacteristic = newCharacteristic;
  }

  Future writeData(String data) async {
    // List<int> bytes = utf8.encode(data);
    // await targetCharacteristic.write(bytes, withoutResponse: true);
    await targetCharacteristic.write(data.codeUnits, withoutResponse: true);
  }
}
