import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class LogLoginAttemptParams {
  final String email;
  final bool success;

  LogLoginAttemptParams({required this.email, required this.success});
}

class LogLoginAttemptUseCase extends UseCase<void, LogLoginAttemptParams> {
  final FirebaseRepository _repository;

  LogLoginAttemptUseCase(this._repository);

  @override
  Future<void> call({LogLoginAttemptParams? params}) async {
    if (params == null) throw Exception("Params cannot be null for LogLoginAttemptUseCase");
    await _repository.logLoginAttempt(params.email, params.success);
  }
}
