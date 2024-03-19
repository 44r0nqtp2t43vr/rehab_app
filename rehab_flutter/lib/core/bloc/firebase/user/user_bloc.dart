import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final RegisterUserUseCase _registerUserUseCase;

  UserBloc(
    this._registerUserUseCase,
  ) : super(const UserNone()) {
    on<RegisterEvent>(onRegisterUser);
  }

  void onRegisterUser(RegisterEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      await _registerUserUseCase(params: event.registerData);
      emit(const UserDone());
    } catch (e) {
      emit(UserNone(errorMessage: e.toString()));
    }
  }
}
