import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class SubmitStandardOneUseCase implements UseCase<AppUser, String> {
  final FirebaseRepository _firebaseRepository;

  SubmitStandardOneUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({String? params}) {
    try {
      return _firebaseRepository.submitStandardOne(params!);
    } catch (e) {
      throw SubmitStandardOneException(e.toString());
    }
  }
}

class SubmitStandardOneException implements Exception {
  final String message;

  SubmitStandardOneException(this.message);
}
