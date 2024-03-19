import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LogsState {}

class LogsInitial extends LogsState {}

class LogsLoading extends LogsState {}

class LogsLoaded extends LogsState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> logs;

  LogsLoaded(this.logs);
}

class LogsError extends LogsState {
  final String message;

  LogsError(this.message);
}
