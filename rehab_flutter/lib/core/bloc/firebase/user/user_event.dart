import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';
import 'package:rehab_flutter/features/tab_profile/domain/entities/edit_user_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

abstract class UserEvent extends Equatable {
  final String? userId;
  final AppUser? user;
  final RegisterData? registerData;
  final LoginData? loginData;
  final AddPlanData? addPlanData;
  final ResultsData? resultsData;
  final StandardData? standardData;
  final PassiveData? passiveData;
  final EditUserData? editUserData;

  const UserEvent({
    this.userId,
    this.user,
    this.registerData,
    this.loginData,
    this.addPlanData,
    this.resultsData,
    this.standardData,
    this.passiveData,
    this.editUserData,
  });

  @override
  List<Object> get props => [userId!, user!, registerData!, loginData!, addPlanData!, resultsData!, standardData!, editUserData!];
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

class SubmitPassiveEvent extends UserEvent {
  const SubmitPassiveEvent(PassiveData passiveData) : super(passiveData: passiveData);
}

class ResetSessionEvent extends UserEvent {
  const ResetSessionEvent(PassiveData passiveData) : super(passiveData: passiveData);
}

class LogoutEvent extends UserEvent {
  const LogoutEvent(AppUser user) : super(user: user);
}

class EditUserEvent extends UserEvent {
  const EditUserEvent(EditUserData editUserData) : super(editUserData: editUserData);
}
