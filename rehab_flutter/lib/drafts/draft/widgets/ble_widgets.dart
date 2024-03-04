// bluetooth_widgets.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothWidgets {
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  final String targetDeviceName = "Gloves_BLE_01";
  bool isDeviceConnected = false;

  void startScan(Function(BluetoothDevice) onDeviceFound) {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.platformName == targetDeviceName) {
          FlutterBluePlus.stopScan();
          onDeviceFound(result.device);
          break;
        }
      }
    });
  }

  Future<void> connectToDevice() async {
    if (targetDevice != null) {
      await targetDevice!.connect();
      isDeviceConnected = true;
      discoverServices();
    }
  }

  Future<void> discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice!.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toUpperCase() == "0000FFE0-0000-1000-8000-00805F9B34FB") {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toUpperCase() == "0000FFE2-0000-1000-8000-00805F9B34FB") {
            targetCharacteristic = characteristic;
          }
        }
      }
    }
  }

  void sendPattern(String data) {
    if (targetCharacteristic == null) return;
    targetCharacteristic!.write(data.codeUnits);
  }
}
