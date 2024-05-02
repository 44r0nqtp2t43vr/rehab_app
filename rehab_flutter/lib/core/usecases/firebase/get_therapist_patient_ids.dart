import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetTherapistPatientIdsUseCase implements UseCase<List<String>, String> {
  final FirebaseRepository _firebaseRepository;

  GetTherapistPatientIdsUseCase(this._firebaseRepository);

  @override
  Future<List<String>> call({String? params}) {
    try {
      return _firebaseRepository.getTherapistPatientIds(params!);
    } catch (e) {
      throw GetTherapistPatientIdsException(e.toString());
    }
  }
}

class GetTherapistPatientIdsException implements Exception {
  final String message;

  GetTherapistPatientIdsException(this.message);
}
