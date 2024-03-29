import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/add_plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_pretest.dart';

import 'package:rehab_flutter/core/usecases/firebase/login_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_standard_one.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final RegisterUserUseCase _registerUserUseCase;
  final LoginUserUseCase _loginUserUseCase;
  final AddPlanUseCase _addPlanUseCase;
  final SubmitPretestUseCase _submitPretestUseCase;
  final SubmitStandardOneUseCase _submitStandardOneUseCase;

  UserBloc(
    this._registerUserUseCase,
    this._loginUserUseCase,
    this._addPlanUseCase,
    this._submitPretestUseCase,
    this._submitStandardOneUseCase,
  ) : super(const UserNone()) {
    on<ResetEvent>(onResetUser);
    on<RegisterEvent>(onRegisterUser);
    on<LoginEvent>(onLoginUser);
    on<AddPlanEvent>(onAddPlan);
    on<SubmitPretestEvent>(onSubmitPretest);
    on<SubmitStandardOneEvent>(onSubmitStandardOne);
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

  void onSubmitPretest(SubmitPretestEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final updatedUser = await _submitPretestUseCase(params: event.pretestData);
      emit(UserDone(currentUser: updatedUser));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }

  void onSubmitStandardOne(SubmitStandardOneEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final updatedUser = await _submitStandardOneUseCase(params: event.userId);
      emit(UserDone(currentUser: updatedUser));
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }
}
