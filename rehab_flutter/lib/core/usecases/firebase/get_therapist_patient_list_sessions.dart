import 'package:rehab_flutter/core/entities/patient_sessions.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetTherapistPatientListSessionsUseCase implements UseCase<List<PatientSessions>, List<String>> {
  final FirebaseRepository _firebaseRepository;

  GetTherapistPatientListSessionsUseCase(this._firebaseRepository);

  @override
  Future<List<PatientSessions>> call({List<String>? params}) {
    try {
      return _firebaseRepository.getTherapistPatientListSessions(params!);
    } catch (e) {
      throw GetTherapistPatientListSessionsException(e.toString());
    }
  }
}

class GetTherapistPatientListSessionsException implements Exception {
  final String message;

  GetTherapistPatientListSessionsException(this.message);
}
