import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';

class AssignPatientUseCase implements UseCase<void, AssignPatientData> {
  final FirebaseRepository _firebaseRepository;

  AssignPatientUseCase(this._firebaseRepository);

  @override
  Future<void> call({AssignPatientData? params}) {
    try {
      return _firebaseRepository.assignPatient(params!);
    } catch (e) {
      throw AssignPatientException(e.toString());
    }
  }
}

class AssignPatientException implements Exception {
  final String message;

  AssignPatientException(this.message);
}
