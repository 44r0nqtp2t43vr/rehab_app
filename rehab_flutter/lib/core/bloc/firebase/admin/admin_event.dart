import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/admin.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class ResetAdminEvent extends AdminEvent {
  const ResetAdminEvent();
}

class GetAdminEvent extends AdminEvent {
  const GetAdminEvent(Admin currentAdmin) : super();
}

class LogoutAdminEvent extends AdminEvent {
  const LogoutAdminEvent() : super();
}
