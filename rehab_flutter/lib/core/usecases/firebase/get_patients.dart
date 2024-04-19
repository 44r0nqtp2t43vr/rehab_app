import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetPatientsUseCase implements UseCase<List<String>, void> {
  final FirebaseRepository _firebaseRepository;

  GetPatientsUseCase(this._firebaseRepository);

  @override
  Future<List<String>> call({void params}) {
    try {
      return _firebaseRepository.getPatientsIds();
    } catch (e) {
      throw GetPatientsException(e.toString());
    }
  }
}

class GetPatientsException implements Exception {
  final String message;

  GetPatientsException(this.message);
}
