import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';

class EditUserSessionUseCase implements UseCase<AppUser, EditSessionData> {
  final FirebaseRepository _firebaseRepository;

  EditUserSessionUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({EditSessionData? params}) {
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
