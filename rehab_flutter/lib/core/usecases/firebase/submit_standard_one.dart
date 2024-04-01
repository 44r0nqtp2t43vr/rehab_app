import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';

class SubmitStandardUseCase implements UseCase<AppUser, StandardData> {
  final FirebaseRepository _firebaseRepository;

  SubmitStandardUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({StandardData? params}) {
    try {
      return _firebaseRepository.submitStandard(params!);
    } catch (e) {
      throw SubmitStandardOneException(e.toString());
    }
  }
}

class SubmitStandardOneException implements Exception {
  final String message;

  SubmitStandardOneException(this.message);
}
