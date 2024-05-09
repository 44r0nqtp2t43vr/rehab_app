import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

class SubmitTestUseCase implements UseCase<Session, ResultsData> {
  final FirebaseRepository _firebaseRepository;

  SubmitTestUseCase(this._firebaseRepository);

  @override
  Future<Session> call({ResultsData? params}) {
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
