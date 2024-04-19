import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetUserUseCase implements UseCase<dynamic, String?> {
  final FirebaseRepository _firebaseRepository;

  GetUserUseCase(this._firebaseRepository);

  @override
  Future<dynamic> call({String? params}) {
    try {
      return _firebaseRepository.getUser(params!);
    } catch (e) {
      throw GetUserException(e.toString());
    }
  }
}

class GetUserException implements Exception {
  final String message;

  GetUserException(this.message);
}
