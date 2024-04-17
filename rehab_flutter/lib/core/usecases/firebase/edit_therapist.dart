import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_therapist_data.dart';

class EditTherapistUseCase implements UseCase<Therapist, EditTherapistData> {
  final FirebaseRepository _firebaseRepository;

  EditTherapistUseCase(this._firebaseRepository);

  @override
  Future<Therapist> call({EditTherapistData? params}) {
    try {
      return _firebaseRepository.editTherapist(params!);
    } catch (e) {
      throw EditTherapistException(e.toString());
    }
  }
}

class EditTherapistException implements Exception {
  final String message;

  EditTherapistException(this.message);
}
