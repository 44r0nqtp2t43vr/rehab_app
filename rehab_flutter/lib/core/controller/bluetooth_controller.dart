import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BluetoothController extends GetxController {
  StreamSubscription? scanSubscription;
  List<BluetoothDevice> devicesList = [];

  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;

  Future<Stream<List<ScanResult>>> scanDevices() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    return FlutterBluePlus.scanResults;
  }

  Future<void> connectToDevice(BluetoothDevice targetDevice) async {
    this.targetDevice = targetDevice;
    await this.targetDevice!.connect(autoConnect: false);
  }

  Future<List<BluetoothService>> discoverServices() async {
    final services = await targetDevice!.discoverServices();
    return services;
  }

  void sendPattern(BluetoothCharacteristic targetCharacteristic, String data) {
    targetCharacteristic.write(data.codeUnits);
  }

  Future<void> disconnectDevice() async {
    await targetDevice!.disconnect();
    targetDevice = null;
    targetCharacteristic = null;
  }

  void updateCharacteristic(BluetoothCharacteristic newCharacteristic) {
    targetCharacteristic = newCharacteristic;
  }

  Future writeData(String data) async {
    // List<int> bytes = utf8.encode(data);
    // await targetCharacteristic.write(bytes, withoutResponse: true);
    await targetCharacteristic!.write(data.codeUnits, withoutResponse: true);
  }
}
