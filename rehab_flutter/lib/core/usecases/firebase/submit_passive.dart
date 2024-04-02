import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class SubmitPassiveUseCase implements UseCase<AppUser, String> {
  final FirebaseRepository _firebaseRepository;

  SubmitPassiveUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({String? params}) {
    try {
      return _firebaseRepository.submitPassive(params!);
    } catch (e) {
      throw SubmitPassiveException(e.toString());
    }
  }
}

class SubmitPassiveException implements Exception {
  final String message;

  SubmitPassiveException(this.message);
}
