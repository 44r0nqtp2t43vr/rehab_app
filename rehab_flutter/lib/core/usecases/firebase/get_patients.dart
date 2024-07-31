import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetPatientsUseCase implements UseCase<List<AppUser>, void> {
  final FirebaseRepository _firebaseRepository;

  GetPatientsUseCase(this._firebaseRepository);

  @override
  Future<List<AppUser>> call({void params}) {
    try {
      return _firebaseRepository.getAllPatients();
    } catch (e) {
      throw GetPatientsException(e.toString());
    }
  }
}

class GetPatientsException implements Exception {
  final String message;

  GetPatientsException(this.message);
}
