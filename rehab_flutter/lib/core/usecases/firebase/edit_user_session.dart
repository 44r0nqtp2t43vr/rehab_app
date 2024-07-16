import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';

class EditUserSessionUseCase implements UseCase<void, EditSessionData> {
  final FirebaseRepository _firebaseRepository;

  EditUserSessionUseCase(this._firebaseRepository);

  @override
  Future<void> call({EditSessionData? params}) {
    try {
      return _firebaseRepository.editUserSession(params!);
    } catch (e) {
      throw EditUserSessionException(e.toString());
    }
  }
}

class EditUserSessionException implements Exception {
  final String message;

  EditUserSessionException(this.message);
}
