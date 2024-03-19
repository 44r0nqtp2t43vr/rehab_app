import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

abstract class UserEvent extends Equatable {
  final RegisterData? registerData;

  const UserEvent({this.registerData});

  @override
  List<Object> get props => [registerData!];
}

class RegisterEvent extends UserEvent {
  const RegisterEvent(RegisterData registerData) : super(registerData: registerData);
}
