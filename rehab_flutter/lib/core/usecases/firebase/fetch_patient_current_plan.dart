import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class FetchPatientCurrentPlanUseCase implements UseCase<Plan, String> {
  final FirebaseRepository _firebaseRepository;

  FetchPatientCurrentPlanUseCase(this._firebaseRepository);

  @override
  Future<Plan> call({String? params}) {
    try {
      return _firebaseRepository.fetchPatientCurrentPlan(params!);
    } catch (e) {
      throw FetchPatientCurrentPlanException(e.toString());
    }
  }
}

class FetchPatientCurrentPlanException implements Exception {
  final String message;

  FetchPatientCurrentPlanException(this.message);
}
