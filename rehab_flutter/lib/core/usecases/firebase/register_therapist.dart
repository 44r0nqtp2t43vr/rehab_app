import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_therapist_data.dart';

class RegisterTherapistUseCase implements UseCase<void, RegisterTherapistData> {
  final FirebaseRepository _firebaseRepository;

  RegisterTherapistUseCase(this._firebaseRepository);

  @override
  Future<void> call({RegisterTherapistData? params}) {
    try {
      return _firebaseRepository.registerTherapist(params!);
    } catch (e) {
      throw RegisterTherapistException(e.toString());
    }
  }
}

class RegisterTherapistException implements Exception {
  final String message;

  RegisterTherapistException(this.message);
}
