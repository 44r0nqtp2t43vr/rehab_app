import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_physician_data.dart';

class EditPhysicianUseCase implements UseCase<Physician, EditPhysicianData> {
  final FirebaseRepository _firebaseRepository;

  EditPhysicianUseCase(this._firebaseRepository);

  @override
  Future<Physician> call({EditPhysicianData? params}) {
    try {
      return _firebaseRepository.editPhysician(params!);
    } catch (e) {
      throw EditPhysicianException(e.toString());
    }
  }
}

class EditPhysicianException implements Exception {
  final String message;

  EditPhysicianException(this.message);
}
