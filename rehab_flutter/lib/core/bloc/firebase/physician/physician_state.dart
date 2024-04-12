import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/physician.dart';

abstract class PhysicianState extends Equatable {
  final Physician? currentPhysician;
  final String? errorMessage;
  final dynamic data;

  const PhysicianState({this.currentPhysician, this.errorMessage, this.data});

  @override
  List<Object> get props => [currentPhysician!, errorMessage!, data!];
}

class PhysicianNone extends PhysicianState {
  const PhysicianNone({String? errorMessage, dynamic data}) : super(errorMessage: errorMessage, data: data);
}

class PhysicianLoading extends PhysicianState {
  const PhysicianLoading();
}

class PhysicianDone extends PhysicianState {
  const PhysicianDone({Physician? currentPhysician}) : super(currentPhysician: currentPhysician);
}
