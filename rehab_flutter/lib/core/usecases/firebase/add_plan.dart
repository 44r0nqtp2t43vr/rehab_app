import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';

class AddPlanUseCase implements UseCase<AppUser, AddPlanData> {
  final FirebaseRepository _firebaseRepository;

  AddPlanUseCase(this._firebaseRepository);

  @override
  Future<AppUser> call({AddPlanData? params}) {
    try {
      return _firebaseRepository.addPlan(params!);
    } catch (e) {
      throw AddPlanException(e.toString());
    }
  }
}

class AddPlanException implements Exception {
  final String message;

  AddPlanException(this.message);
}
