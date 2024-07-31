import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetAdminPatientNumbersUseCase implements UseCase<List<int>, void> {
  final FirebaseRepository _firebaseRepository;

  GetAdminPatientNumbersUseCase(this._firebaseRepository);

  @override
  Future<List<int>> call({void params}) {
    try {
      return _firebaseRepository.getAdminPatientNumbers();
    } catch (e) {
      throw GetAdminPatientNumbersException(e.toString());
    }
  }
}

class GetAdminPatientNumbersException implements Exception {
  final String message;

  GetAdminPatientNumbersException(this.message);
}
