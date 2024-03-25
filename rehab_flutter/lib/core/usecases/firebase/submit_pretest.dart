import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/pre_test_dummy/pretest_session_generation_data.dart';

class SubmitPretestUseCase implements UseCase<void, PretestData> {
  final FirebaseRepository _firebaseRepository;

  SubmitPretestUseCase(this._firebaseRepository);

  @override
  Future<void> call({PretestData? params}) {
    try {
      return _firebaseRepository.submitPretest(params!);
    } catch (e) {
      throw SubmitPretestException(e.toString());
    }
  }
}

class SubmitPretestException implements Exception {
  final String message;

  SubmitPretestException(this.message);
}
