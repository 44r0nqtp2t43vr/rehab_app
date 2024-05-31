import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class FetchPatientPlansUseCase implements UseCase<List<Plan>, String> {
  final FirebaseRepository _firebaseRepository;

  FetchPatientPlansUseCase(this._firebaseRepository);

  @override
  Future<List<Plan>> call({String? params}) {
    try {
      return _firebaseRepository.fetchPatientPlans(params!);
    } catch (e) {
      throw FetchPatientPlansException(e.toString());
    }
  }
}

class FetchPatientPlansException implements Exception {
  final String message;

  FetchPatientPlansException(this.message);
}
