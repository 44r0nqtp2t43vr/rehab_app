import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_physician_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_physician_data.dart';

abstract class PhysicianEvent extends Equatable {
  final Physician? currentPhysician;
  final RegisterPhysicianData? registerData;
  final AssignPatientData? assignData;
  final EditPhysicianData? editData;

  const PhysicianEvent({
    this.currentPhysician,
    this.registerData,
    this.assignData,
    this.editData,
  });

  @override
  List<Object> get props => [currentPhysician!, registerData!, assignData!, editData!];
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

class EditPhysicianEvent extends PhysicianEvent {
  const EditPhysicianEvent(EditPhysicianData editData) : super(editData: editData);
}

class LogoutPhysicianEvent extends PhysicianEvent {
  const LogoutPhysicianEvent(Physician currentPhysician) : super(currentPhysician: currentPhysician);
}
