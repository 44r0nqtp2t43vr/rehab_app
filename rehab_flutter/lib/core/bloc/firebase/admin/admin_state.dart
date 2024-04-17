import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/admin.dart';

abstract class AdminState extends Equatable {
  final Admin? currentAdmin;
  final String? errorMessage;
  final dynamic data;

  const AdminState({this.currentAdmin, this.errorMessage, this.data});

  @override
  List<Object> get props => [currentAdmin!, errorMessage!, data!];
}

class AdminNone extends AdminState {
  const AdminNone({String? errorMessage, dynamic data}) : super(errorMessage: errorMessage, data: data);
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminDone extends AdminState {
  const AdminDone({Admin? currentAdmin}) : super(currentAdmin: currentAdmin);
}
