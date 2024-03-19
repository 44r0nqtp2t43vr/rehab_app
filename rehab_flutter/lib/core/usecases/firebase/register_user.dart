import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

class RegisterUserUseCase implements UseCase<void, RegisterData> {
  final FirebaseRepository _firebaseRepository;

  RegisterUserUseCase(this._firebaseRepository);

  @override
  Future<void> call({RegisterData? params}) {
    try {
      return _firebaseRepository.registerUser(params!);
    } catch (e) {
      throw RegisterUserException(e.toString());
    }
  }
}

class RegisterUserException implements Exception {
  final String message;

  RegisterUserException(this.message);
}
