import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class ResetSessionUseCase implements UseCase<Session, AppUser> {
  final FirebaseRepository _firebaseRepository;

  ResetSessionUseCase(this._firebaseRepository);

  @override
  Future<Session> call({AppUser? params}) {
    try {
      return _firebaseRepository.resetSession(params!);
    } catch (e) {
      throw ResetSessionException(e.toString());
    }
  }
}

class ResetSessionException implements Exception {
  final String message;

  ResetSessionException(this.message);
}
