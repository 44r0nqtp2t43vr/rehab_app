import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class UserState extends Equatable {
  final AppUser? currentUser;
  final String? errorMessage;
  final dynamic data;

  const UserState({this.currentUser, this.errorMessage, this.data});

  @override
  List<Object> get props => [currentUser!, errorMessage!];
}

class UserNone extends UserState {
  const UserNone({String? errorMessage, dynamic data}) : super(errorMessage: errorMessage, data: data);
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserDone extends UserState {
  const UserDone({AppUser? currentUser}) : super(currentUser: currentUser);
}
