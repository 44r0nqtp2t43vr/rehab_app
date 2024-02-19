import 'package:equatable/equatable.dart';
import 'package:flutter_blue/flutter_blue.dart';

abstract class BluetoothEvent extends Equatable {
  final BluetoothCharacteristic? targetCharacteristic;
  final String? data;

  const BluetoothEvent({this.targetCharacteristic, this.data});

  @override
  List<Object> get props => [targetCharacteristic!, data!];
}

// class GetServices extends RemoteServicesEvent {
//   const GetServices(BluetoothDevice targetDevice)
//       : super(targetDevice: targetDevice);
// }

class UpdateCharaEvent extends BluetoothEvent {
  const UpdateCharaEvent(BluetoothCharacteristic targetCharacteristic)
      : super(targetCharacteristic: targetCharacteristic);
}

class WriteDataEvent extends BluetoothEvent {
  const WriteDataEvent(String data) : super(data: data);
}
