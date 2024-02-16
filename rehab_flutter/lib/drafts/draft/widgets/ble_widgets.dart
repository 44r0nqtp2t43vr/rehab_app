// bluetooth_widgets.dart
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothWidgets {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  final String targetDeviceName = "Gloves_BLE_01";
  bool isDeviceConnected = false;

  void startScan(Function(BluetoothDevice) onDeviceFound) {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == targetDeviceName) {
          flutterBlue.stopScan();
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
    services.forEach((service) {
      if (service.uuid.toString().toUpperCase() ==
          "0000FFE0-0000-1000-8000-00805F9B34FB") {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase() ==
              "0000FFE2-0000-1000-8000-00805F9B34FB") {
            targetCharacteristic = characteristic;
          }
        });
      }
    });
  }

  void sendPattern(String data) {
    if (targetCharacteristic == null) return;
    targetCharacteristic!.write(data.codeUnits);
  }
}
