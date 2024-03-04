import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/resources/data_state.dart';

abstract class BluetoothRepository {
  // API methods
  Future<DataState<List<BluetoothDevice>>> scanDevices();
  Future<void> updateCharacteristic(BluetoothCharacteristic targetCharacteristic);
  Future<void> writeData(String data);
}
