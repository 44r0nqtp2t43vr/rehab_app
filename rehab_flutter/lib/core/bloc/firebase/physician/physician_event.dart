import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_physician_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';

abstract class PhysicianEvent extends Equatable {
  final Physician? currentPhysician;
  final RegisterPhysicianData? registerData;
  final AssignPatientData? assignData;

  const PhysicianEvent({
    this.currentPhysician,
    this.registerData,
    this.assignData,
  });

  @override
  List<Object> get props => [currentPhysician!, registerData!, assignData!];
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

class AssignPatientEvent extends PhysicianEvent {
  const AssignPatientEvent(AssignPatientData assignData) : super(assignData: assignData);
}

class LogoutPhysicianEvent extends PhysicianEvent {
  const LogoutPhysicianEvent(Physician currentPhysician) : super(currentPhysician: currentPhysician);
}
