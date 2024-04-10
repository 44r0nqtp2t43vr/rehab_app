import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';

class LoginUserUseCase implements UseCase<dynamic, LoginData> {
  final FirebaseRepository _firebaseRepository;

  LoginUserUseCase(this._firebaseRepository);

  @override
  Future<dynamic> call({LoginData? params}) {
    try {
      return _firebaseRepository.loginUser(params!);
    } catch (e) {
      throw LoginUserException(e.toString());
    }
  }
}

class LoginUserException implements Exception {
  final String message;

  LoginUserException(this.message);
}
