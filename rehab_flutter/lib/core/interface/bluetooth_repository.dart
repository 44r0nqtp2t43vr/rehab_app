import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothRepository {
  // API methods
  // Future<Stream<List<ScanResult>>> getScanResults();
  // Future<List<BluetoothService>> getServices();
  // Future<void> connectToDevice(BluetoothDevice targetDevice);
  Future<void> updateCharacteristic(BluetoothCharacteristic targetCharacteristic);
  Future<void> writeData(String data);
}
