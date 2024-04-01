import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

abstract class UserEvent extends Equatable {
  final RegisterData? registerData;
  final LoginData? loginData;
  final AddPlanData? addPlanData;
  final ResultsData? resultsData;
  final StandardData? standardData;

  const UserEvent({
    this.registerData,
    this.loginData,
    this.addPlanData,
    this.resultsData,
    this.standardData,
  });

  @override
  List<Object> get props => [registerData!, loginData!, addPlanData!, resultsData!, standardData!];
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

class SubmitTestEvent extends UserEvent {
  const SubmitTestEvent(ResultsData resultsData) : super(resultsData: resultsData);
}

class SubmitStandardEvent extends UserEvent {
  const SubmitStandardEvent(StandardData standardData) : super(standardData: standardData);
}
