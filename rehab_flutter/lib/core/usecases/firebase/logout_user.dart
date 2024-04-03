import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class LogoutUserUseCase implements UseCase<void, void> {
  final FirebaseRepository _firebaseRepository;

  LogoutUserUseCase(this._firebaseRepository);

  @override
  Future<void> call({void params}) {
    try {
      return _firebaseRepository.logoutUser();
    } catch (e) {
      throw LogoutUserException(e.toString());
    }
  }
}

class LogoutUserException implements Exception {
  final String message;

  LogoutUserException(this.message);
}
