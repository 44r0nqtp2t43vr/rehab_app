import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class BluetoothState extends Equatable {
  final DioException? error;

  const BluetoothState({this.error});

  @override
  List<Object> get props => [error!];
}

class BluetoothNone extends BluetoothState {
  const BluetoothNone();
}

class BluetoothLoading extends BluetoothState {
  const BluetoothLoading();
}

class BluetoothDone extends BluetoothState {
  const BluetoothDone();
}
