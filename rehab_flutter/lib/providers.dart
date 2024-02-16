import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue/flutter_blue.dart';

// Provider for the connected Bluetooth device
final connectedDeviceProvider = StateProvider<BluetoothDevice?>((ref) => null);

// Provider for the target Bluetooth characteristic
final targetCharacteristicProvider =
    StateProvider<BluetoothCharacteristic?>((ref) => null);
