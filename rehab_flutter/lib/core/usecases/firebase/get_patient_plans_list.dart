import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class GetPatientPlansListUseCase implements UseCase<List<Plan>, String> {
  final FirebaseRepository _firebaseRepository;

  GetPatientPlansListUseCase(this._firebaseRepository);

  @override
  Future<List<Plan>> call({String? params}) {
    try {
      return _firebaseRepository.getPatientPlansList(params!);
    } catch (e) {
      throw GetPatientPlansListException(e.toString());
    }
  }
}

class GetPatientPlansListException implements Exception {
  final String message;

  GetPatientPlansListException(this.message);
}
