import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_data.dart';

class SubmitPassiveUseCase implements UseCase<Session, PassiveData> {
  final FirebaseRepository _firebaseRepository;

  SubmitPassiveUseCase(this._firebaseRepository);

  @override
  Future<Session> call({PassiveData? params}) {
    try {
      return _firebaseRepository.submitPassive(params!);
    } catch (e) {
      throw SubmitPassiveException(e.toString());
    }
  }
}

class SubmitPassiveException implements Exception {
  final String message;

  SubmitPassiveException(this.message);
}
