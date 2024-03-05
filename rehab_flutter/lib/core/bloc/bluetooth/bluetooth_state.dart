import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothAppState extends Equatable {
  final Stream<List<ScanResult>>? scanResults;
  final List<BluetoothService>? services;
  final DioException? error;

  const BluetoothAppState({this.scanResults, this.services, this.error});

  @override
  List<Object> get props => [scanResults!, services!, error!];
}

class BluetoothNone extends BluetoothAppState {
  const BluetoothNone();
}

class BluetoothLoading extends BluetoothAppState {
  const BluetoothLoading();
}

class BluetoothDone extends BluetoothAppState {
  const BluetoothDone({Stream<List<ScanResult>>? scanResults, List<BluetoothService>? services}) : super(scanResults: scanResults, services: services);
}
