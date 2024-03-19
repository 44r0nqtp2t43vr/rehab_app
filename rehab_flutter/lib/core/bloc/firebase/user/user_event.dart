import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

abstract class UserEvent extends Equatable {
  final RegisterData? registerData;
  final LoginData? loginData;

  const UserEvent({this.registerData, this.loginData});

  @override
  List<Object> get props => [registerData!, loginData!];
}

class ResetEvent extends UserEvent {
  const ResetEvent();
}

class RegisterEvent extends UserEvent {
  const RegisterEvent(RegisterData registerData) : super(registerData: registerData);
}

class LoginEvent extends UserEvent {
  const LoginEvent(LoginData loginData) : super(loginData: loginData);
}
