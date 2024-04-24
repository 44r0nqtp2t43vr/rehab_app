import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_therapist_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_therapist_data.dart';

abstract class TherapistEvent extends Equatable {
  final Therapist? currentTherapist;
  final RegisterTherapistData? registerData;
  final EditTherapistData? editData;

  const TherapistEvent({
    this.currentTherapist,
    this.registerData,
    this.editData,
  });

  @override
  List<Object> get props => [currentTherapist!, registerData!, editData!];
}

class ResetTherapistEvent extends TherapistEvent {
  const ResetTherapistEvent();
}

class GetTherapistEvent extends TherapistEvent {
  const GetTherapistEvent(Therapist currentTherapist) : super(currentTherapist: currentTherapist);
}

class RegisterTherapistEvent extends TherapistEvent {
  const RegisterTherapistEvent(RegisterTherapistData registerData) : super(registerData: registerData);
}

class EditTherapistEvent extends TherapistEvent {
  const EditTherapistEvent(EditTherapistData editData) : super(editData: editData);
}

class LogoutTherapistEvent extends TherapistEvent {
  const LogoutTherapistEvent(Therapist currentTherapist) : super(currentTherapist: currentTherapist);
}
