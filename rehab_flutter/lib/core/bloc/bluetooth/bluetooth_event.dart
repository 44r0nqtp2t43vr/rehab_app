import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothEvent extends Equatable {
  final BluetoothDevice? targetDevice;
  final BluetoothCharacteristic? targetCharacteristic;
  final String? data;

  const BluetoothEvent({this.targetDevice, this.targetCharacteristic, this.data});

  @override
  List<Object> get props => [targetDevice!, targetCharacteristic!, data!];
}

class ScanDevicesEvent extends BluetoothEvent {
  const ScanDevicesEvent() : super();
}

class ConnectDeviceEvent extends BluetoothEvent {
  const ConnectDeviceEvent(BluetoothDevice targetDevice) : super(targetDevice: targetDevice);
}

class DisconnectDeviceEvent extends BluetoothEvent {
  const DisconnectDeviceEvent() : super();
}

class UpdateCharaEvent extends BluetoothEvent {
  const UpdateCharaEvent(BluetoothCharacteristic targetCharacteristic) : super(targetCharacteristic: targetCharacteristic);
}

class WriteDataEvent extends BluetoothEvent {
  const WriteDataEvent(String data) : super(data: data);
}
