import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetTherapistsUseCase implements UseCase<List<String>, void> {
  final FirebaseRepository _firebaseRepository;

  GetTherapistsUseCase(this._firebaseRepository);

  @override
  Future<List<String>> call({void params}) {
    try {
      return _firebaseRepository.getTherapistsIds();
    } catch (e) {
      throw GetTherapistsException(e.toString());
    }
  }
}

class GetTherapistsException implements Exception {
  final String message;

  GetTherapistsException(this.message);
}
