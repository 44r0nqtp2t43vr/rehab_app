import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_physician_data.dart';

abstract class PhysicianEvent extends Equatable {
  final Physician? currentPhysician;
  final RegisterPhysicianData? registerData;

  const PhysicianEvent({
    this.currentPhysician,
    this.registerData,
  });

  @override
  List<Object> get props => [registerData!];
}

class ResetPhysicianEvent extends PhysicianEvent {
  const ResetPhysicianEvent();
}

class GetPhysicianEvent extends PhysicianEvent {
  const GetPhysicianEvent(Physician currentPhysician) : super(currentPhysician: currentPhysician);
}

class RegisterPhysicianEvent extends PhysicianEvent {
  const RegisterPhysicianEvent(RegisterPhysicianData registerData) : super(registerData: registerData);
}
