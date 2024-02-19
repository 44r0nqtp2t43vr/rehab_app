import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the connected Bluetooth device
final connectedDeviceProvider = StateProvider<BluetoothDevice?>((ref) => null);

// Provider for the target Bluetooth characteristic
final targetCharacteristicProvider =
    StateProvider<BluetoothCharacteristic?>((ref) => null);
