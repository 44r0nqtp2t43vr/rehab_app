import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/physician.dart';

abstract class PhysicianState extends Equatable {
  final Physician? currentPhysician;
  final String? errorMessage;

  const PhysicianState({this.currentPhysician, this.errorMessage});

  @override
  List<Object> get props => [currentPhysician!, errorMessage!];
}

class PhysicianNone extends PhysicianState {
  const PhysicianNone({String? errorMessage}) : super(errorMessage: errorMessage);
}

class PhysicianLoading extends PhysicianState {
  const PhysicianLoading();
}

class PhysicianDone extends PhysicianState {
  const PhysicianDone({Physician? currentPhysician}) : super(currentPhysician: currentPhysician);
}
