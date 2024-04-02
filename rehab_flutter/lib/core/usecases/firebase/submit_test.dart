import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

class SubmitTestUseCase implements UseCase<AppUser, ResultsData> {
  final FirebaseRepository _firebaseRepository;

  SubmitTestUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({ResultsData? params}) {
    try {
      return _firebaseRepository.submitTest(params!);
    } catch (e) {
      throw SubmitTestException(e.toString());
    }
  }
}

class SubmitTestException implements Exception {
  final String message;

  SubmitTestException(this.message);
}
