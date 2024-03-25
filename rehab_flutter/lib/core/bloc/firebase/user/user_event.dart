import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/plan_selection/presentation/add_plan_data.dart';
import 'package:rehab_flutter/features/pre_test_dummy/pretest_session_generation_data.dart';

abstract class UserEvent extends Equatable {
  final RegisterData? registerData;
  final LoginData? loginData;
  final AddPlanData? addPlanData;
  final PretestData? pretestData;
  const UserEvent({this.registerData, this.loginData, this.addPlanData, this.pretestData});

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

class FetchTodaySessionEvent extends UserEvent {
  const FetchTodaySessionEvent();
}

class AddPlanEvent extends UserEvent {
  const AddPlanEvent(AddPlanData addPlanData) : super(addPlanData: addPlanData);
}

class SubmitPretestEvent extends UserEvent {
  const SubmitPretestEvent(PretestData pretestData) : super(pretestData: pretestData);
}
