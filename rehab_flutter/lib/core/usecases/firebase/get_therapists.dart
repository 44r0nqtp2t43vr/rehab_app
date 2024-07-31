import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetTherapistsUseCase implements UseCase<List<Therapist>, void> {
  final FirebaseRepository _firebaseRepository;

  GetTherapistsUseCase(this._firebaseRepository);

  @override
  Future<List<Therapist>> call({void params}) {
    try {
      return _firebaseRepository.getAllTherapists();
    } catch (e) {
      throw GetTherapistsException(e.toString());
    }
  }
}

class GetTherapistsException implements Exception {
  final String message;

  GetTherapistsException(this.message);
}
