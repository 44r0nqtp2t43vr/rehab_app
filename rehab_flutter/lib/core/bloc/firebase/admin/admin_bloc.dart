import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_state.dart';
import 'package:rehab_flutter/core/usecases/firebase/logout_user.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final LogoutUserUseCase _logoutUserUseCase;

  AdminBloc(
    this._logoutUserUseCase,
  ) : super(const AdminNone()) {
    on<ResetAdminEvent>(onResetAdmin);
    on<GetAdminEvent>(onGetAdmin);
    on<LogoutAdminEvent>(onLogoutAdmin);
  }

  void onResetAdmin(ResetAdminEvent event, Emitter<AdminState> emit) {
    emit(const AdminNone());
  }

  void onGetAdmin(GetAdminEvent event, Emitter<AdminState> emit) {
    emit(const AdminDone());
  }

  void onLogoutAdmin(LogoutAdminEvent event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      await _logoutUserUseCase();
      emit(const AdminNone());
    } catch (e) {
      emit(const AdminDone());
    }
  }
}
