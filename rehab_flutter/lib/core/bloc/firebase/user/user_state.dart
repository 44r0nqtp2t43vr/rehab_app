import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';

abstract class UserState extends Equatable {
  final AppUser? currentUser;
  final String? errorMessage;

  const UserState({this.currentUser, this.errorMessage});

  @override
  List<Object> get props => [currentUser!, errorMessage!];
}

class UserNone extends UserState {
  const UserNone({String? errorMessage}) : super(errorMessage: errorMessage);
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserDone extends UserState {
  const UserDone({AppUser? currentUser}) : super(currentUser: currentUser);
}

class PlanAdded extends UserState {
  const PlanAdded({AppUser? currentUser}) : super(currentUser: currentUser);
}

class SessionGenerated extends UserState {
  const SessionGenerated({AppUser? currentUser})
      : super(currentUser: currentUser);
}
