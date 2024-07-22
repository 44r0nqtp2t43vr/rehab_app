import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetPatientNumbersUseCase implements UseCase<List<int>, List<String>> {
  final FirebaseRepository _firebaseRepository;

  GetPatientNumbersUseCase(this._firebaseRepository);

  @override
  Future<List<int>> call({List<String>? params}) {
    try {
      return _firebaseRepository.getPatientNumbers(params!);
    } catch (e) {
      throw GetPatientNumbersException(e.toString());
    }
  }
}

class GetPatientNumbersException implements Exception {
  final String message;

  GetPatientNumbersException(this.message);
}
