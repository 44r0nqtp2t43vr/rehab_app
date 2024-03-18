import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

abstract class UserEvent extends Equatable {
  final BuildContext? context;
  final RegisterData? registerData;

  const UserEvent({this.context, this.registerData});

  @override
  List<Object> get props => [context!, registerData!];
}

class RegisterEvent extends UserEvent {
  const RegisterEvent(BuildContext context, RegisterData registerData) : super(context: context, registerData: registerData);
}
