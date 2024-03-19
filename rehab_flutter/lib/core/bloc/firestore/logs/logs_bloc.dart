import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/fetch_login_user_attempt.dart';

import 'logs_event.dart';
import 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  final FetchLoginLogsUseCase _fetchLoginLogsUseCase;

  LogsBloc(this._fetchLoginLogsUseCase) : super(LogsInitial()) {
    on<FetchLogs>(_onFetchLogs);
  }

  Future<void> _onFetchLogs(FetchLogs event, Emitter<LogsState> emit) async {
    emit(LogsLoading());
    try {
      final logs = await _fetchLoginLogsUseCase();
      emit(LogsLoaded(logs));
    } catch (e) {
      emit(LogsError(e.toString()));
    }
  }
}
