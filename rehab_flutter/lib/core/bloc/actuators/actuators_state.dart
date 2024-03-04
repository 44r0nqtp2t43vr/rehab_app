import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class ActuatorsState extends Equatable {
  final DioException? error;

  const ActuatorsState({this.error});

  @override
  List<Object> get props => [error!];
}

class ActuatorsNone extends ActuatorsState {
  const ActuatorsNone();
}

class ActuatorsLoading extends ActuatorsState {
  const ActuatorsLoading();
}

class ActuatorsDone extends ActuatorsState {
  const ActuatorsDone();
}
