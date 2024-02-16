import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BluetoothController extends GetxController {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription? scanSubscription;
  List<BluetoothDevice> devicesList = [];

  late BluetoothCharacteristic targetCharacteristic;

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
    await device.connect(autoConnect: false);
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

  void updateCharacteristic(BluetoothCharacteristic newCharacteristic) {
    targetCharacteristic = newCharacteristic;
  }

  Future writeData(String data) async {
    // List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(data.codeUnits);
  }
}
