import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/tab_profile/domain/entities/edit_user_data.dart';

class EditUserUseCase implements UseCase<AppUser, EditUserData> {
  final FirebaseRepository _firebaseRepository;

  EditUserUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({EditUserData? params}) {
    try {
      return _firebaseRepository.editUser(params!);
    } catch (e) {
      throw EditUserException(e.toString());
    }
  }
}

class EditUserException implements Exception {
  final String message;

  EditUserException(this.message);
}
