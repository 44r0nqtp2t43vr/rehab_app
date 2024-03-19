import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  final String? errorMessage;

  const UserState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}

class UserNone extends UserState {
  const UserNone({String? errorMessage}) : super(errorMessage: errorMessage);
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserDone extends UserState {
  const UserDone() : super();
}
