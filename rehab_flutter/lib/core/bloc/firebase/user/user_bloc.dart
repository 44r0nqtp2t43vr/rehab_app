import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/add_plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_passive.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_test.dart';

import 'package:rehab_flutter/core/usecases/firebase/login_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_standard.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final RegisterUserUseCase _registerUserUseCase;
  final LoginUserUseCase _loginUserUseCase;
  final AddPlanUseCase _addPlanUseCase;
  final SubmitTestUseCase _submitTestUseCase;
  final SubmitStandardUseCase _submitStandardUseCase;
  final SubmitPassiveUseCase _submitPassiveUseCase;

  UserBloc(
    this._registerUserUseCase,
    this._loginUserUseCase,
    this._addPlanUseCase,
    this._submitTestUseCase,
    this._submitStandardUseCase,
    this._submitPassiveUseCase,
  ) : super(const UserNone()) {
    on<ResetEvent>(onResetUser);
    on<RegisterEvent>(onRegisterUser);
    on<LoginEvent>(onLoginUser);
    on<AddPlanEvent>(onAddPlan);
    on<SubmitTestEvent>(onSubmitTest);
    on<SubmitStandardEvent>(onSubmitStandard);
    on<SubmitPassiveEvent>(onSubmitPassive);
  }

  void onResetUser(ResetEvent event, Emitter<UserState> emit) {
    emit(const UserNone());
  }

  void onRegisterUser(RegisterEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      await _registerUserUseCase(params: event.registerData);
      emit(const UserDone(currentUser: null));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }

  void onLoginUser(LoginEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final currentUser = await _loginUserUseCase(params: event.loginData);
      emit(UserDone(currentUser: currentUser));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }

  void onAddPlan(AddPlanEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final currentUser = await _addPlanUseCase(params: event.addPlanData);
      emit(UserDone(currentUser: currentUser));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }

  void onSubmitTest(SubmitTestEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final updatedUser = await _submitTestUseCase(params: event.resultsData);
      emit(UserDone(currentUser: updatedUser));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }

  void onSubmitStandard(SubmitStandardEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final updatedUser = await _submitStandardUseCase(params: event.standardData);
      emit(UserDone(currentUser: updatedUser));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }

  void onSubmitPassive(SubmitPassiveEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final updatedUser = await _submitPassiveUseCase(params: event.userId);
      emit(UserDone(currentUser: updatedUser));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }
}
