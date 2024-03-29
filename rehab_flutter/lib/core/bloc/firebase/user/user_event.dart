import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/pretest_data.dart';

abstract class UserEvent extends Equatable {
  final String? userId;
  final RegisterData? registerData;
  final LoginData? loginData;
  final AddPlanData? addPlanData;
  final PretestData? pretestData;

  const UserEvent({
    this.userId,
    this.registerData,
    this.loginData,
    this.addPlanData,
    this.pretestData,
  });

  @override
  List<Object> get props => [userId!, registerData!, loginData!, addPlanData!, pretestData!];
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

class AddPlanEvent extends UserEvent {
  const AddPlanEvent(AddPlanData addPlanData) : super(addPlanData: addPlanData);
}

class SubmitPretestEvent extends UserEvent {
  const SubmitPretestEvent(PretestData pretestData) : super(pretestData: pretestData);
}

class SubmitStandardOneEvent extends UserEvent {
  const SubmitStandardOneEvent(String userId) : super(userId: userId);
}
