import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/testing/domain/entities/pretest_data.dart';

class SubmitPretestUseCase implements UseCase<AppUser, PretestData> {
  final FirebaseRepository _firebaseRepository;

  SubmitPretestUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({PretestData? params}) {
    try {
      return _firebaseRepository.submitPretest(params!);
    } catch (e) {
      throw SubmitPretestException(e.toString());
    }
  }
}

class SubmitPretestException implements Exception {
  final String message;

  SubmitPretestException(this.message);
}
