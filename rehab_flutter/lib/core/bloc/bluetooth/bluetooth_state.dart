import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothState extends Equatable {
  final List<BluetoothDevice>? devices;
  final DioException? error;

  const BluetoothState({this.devices, this.error});

  @override
  List<Object> get props => [devices!, error!];
}

class BluetoothNone extends BluetoothState {
  const BluetoothNone();
}

class BluetoothLoading extends BluetoothState {
  const BluetoothLoading();
}

class BluetoothDone extends BluetoothState {
  const BluetoothDone({super.devices});
}
