import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserNone extends UserState {
  const UserNone();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserDone extends UserState {
  const UserDone() : super();
}
