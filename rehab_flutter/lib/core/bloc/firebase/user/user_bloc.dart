import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/login_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final RegisterUserUseCase _registerUserUseCase;
  final LoginUserUseCase _loginUserUseCase;

  UserBloc(
    this._registerUserUseCase,
    this._loginUserUseCase,
  ) : super(const UserNone()) {
    on<ResetEvent>(onResetUser);
    on<RegisterEvent>(onRegisterUser);
    on<LoginEvent>(onLoginUser);
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
}
