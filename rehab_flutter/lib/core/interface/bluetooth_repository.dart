import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothRepository {
  // API methods
  Future<Stream<List<ScanResult>>> scanDevices();
  Future<List<BluetoothService>> connectDevice(BluetoothDevice targetDevice);
  Future<void> disconnectDevice();
  Future<void> updateCharacteristic(BluetoothCharacteristic targetCharacteristic);
  Future<void> writeData(String data);
}
