import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  // final RegisterAdminUseCase _registerAdminUseCase;

  AdminBloc(
      // this._registerAdminUseCase,
      )
      : super(const AdminNone()) {
    on<ResetAdminEvent>(onResetAdmin);
    on<GetAdminEvent>(onGetAdmin);
  }

  void onResetAdmin(ResetAdminEvent event, Emitter<AdminState> emit) {
    emit(const AdminNone());
  }

  void onGetAdmin(GetAdminEvent event, Emitter<AdminState> emit) {
    emit(AdminDone(currentAdmin: event.currentAdmin));
  }
}
