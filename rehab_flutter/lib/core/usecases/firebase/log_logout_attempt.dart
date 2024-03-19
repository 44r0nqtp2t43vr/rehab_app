import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class LogLogoutAttemptParams {
  final String email;
  final bool success;

  LogLogoutAttemptParams({required this.email, required this.success});
}

class LogLogoutAttemptUseCase extends UseCase<void, LogLogoutAttemptParams> {
  final FirebaseRepository _repository;

  LogLogoutAttemptUseCase(this._repository);

  @override
  Future<void> call({LogLogoutAttemptParams? params}) async {
    if (params == null) throw Exception("Params cannot be null for LogLogoutAttemptUseCase");
    await _repository.logLogoutAttempt(params.email, params.success);
  }
}
