import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';

class SubmitStandardUseCase implements UseCase<Session, StandardData> {
  final FirebaseRepository _firebaseRepository;

  SubmitStandardUseCase(this._firebaseRepository);

  @override
  Future<Session> call({StandardData? params}) {
    try {
      return _firebaseRepository.submitStandard(params!);
    } catch (e) {
      throw SubmitStandardException(e.toString());
    }
  }
}

class SubmitStandardException implements Exception {
  final String message;

  SubmitStandardException(this.message);
}
