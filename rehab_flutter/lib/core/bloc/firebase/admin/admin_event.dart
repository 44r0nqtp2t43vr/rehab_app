import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/admin.dart';

abstract class AdminEvent extends Equatable {
  final Admin? currentAdmin;

  const AdminEvent({
    this.currentAdmin,
  });

  @override
  List<Object> get props => [currentAdmin!];
}

class ResetAdminEvent extends AdminEvent {
  const ResetAdminEvent();
}

class GetAdminEvent extends AdminEvent {
  const GetAdminEvent(Admin currentAdmin) : super(currentAdmin: currentAdmin);
}

class LogoutAdminEvent extends AdminEvent {
  const LogoutAdminEvent(Admin currentAdmin) : super(currentAdmin: currentAdmin);
}
