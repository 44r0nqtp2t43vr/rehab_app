import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_physician_data.dart';

class RegisterPhysicianUseCase implements UseCase<void, RegisterPhysicianData> {
  final FirebaseRepository _firebaseRepository;

  RegisterPhysicianUseCase(this._firebaseRepository);

  @override
  Future<void> call({RegisterPhysicianData? params}) {
    try {
      return _firebaseRepository.registerPhysician(params!);
    } catch (e) {
      throw RegisterPhysicianException(e.toString());
    }
  }
}

class RegisterPhysicianException implements Exception {
  final String message;

  RegisterPhysicianException(this.message);
}
