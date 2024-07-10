import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetUserDetailsUseCase implements UseCase<dynamic, String?> {
  final FirebaseRepository _firebaseRepository;

  GetUserDetailsUseCase(this._firebaseRepository);

  @override
  Future<dynamic> call({String? params}) {
    try {
      return _firebaseRepository.getUserDetails(params!);
    } catch (e) {
      throw GetUserDetailsException(e.toString());
    }
  }
}

class GetUserDetailsException implements Exception {
  final String message;

  GetUserDetailsException(this.message);
}
