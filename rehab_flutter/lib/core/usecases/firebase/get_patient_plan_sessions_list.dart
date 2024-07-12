import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetPatientPlanSessionsListUseCase implements UseCase<List<Session>, PatientPlan> {
  final FirebaseRepository _firebaseRepository;

  GetPatientPlanSessionsListUseCase(this._firebaseRepository);

  @override
  Future<List<Session>> call({PatientPlan? params}) {
    try {
      return _firebaseRepository.getPatientPlanSessionsList(params!);
    } catch (e) {
      throw GetPatientPlansListException(e.toString());
    }
  }
}

class GetPatientPlansListException implements Exception {
  final String message;

  GetPatientPlansListException(this.message);
}
