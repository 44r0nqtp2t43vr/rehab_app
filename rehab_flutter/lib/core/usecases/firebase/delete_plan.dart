import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/delete_plan_data.dart';

class DeletePlanUseCase implements UseCase<void, DeletePlanData> {
  final FirebaseRepository _firebaseRepository;

  DeletePlanUseCase(this._firebaseRepository);

  @override
  Future<void> call({DeletePlanData? params}) {
    try {
      return _firebaseRepository.deletePlan(params!);
    } catch (e) {
      throw DeletePlanException(e.toString());
    }
  }
}

class DeletePlanException implements Exception {
  final String message;

  DeletePlanException(this.message);
}
