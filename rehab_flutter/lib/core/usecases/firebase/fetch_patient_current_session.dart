import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class FetchPatientCurrentSessionUseCase implements UseCase<Session, String> {
  final FirebaseRepository _firebaseRepository;

  FetchPatientCurrentSessionUseCase(this._firebaseRepository);

  @override
  Future<Session> call({String? params}) {
    try {
      return _firebaseRepository.fetchPatientCurrentSession(params!);
    } catch (e) {
      throw FetchPatientCurrentSessionException(e.toString());
    }
  }
}

class FetchPatientCurrentSessionException implements Exception {
  final String message;

  FetchPatientCurrentSessionException(this.message);
}
