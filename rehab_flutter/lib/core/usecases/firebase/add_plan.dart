import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/plan_selection/presentation/add_plan_data.dart';

class AddPlanUseCase implements UseCase<void, AddPlanData> {
  final FirebaseRepository _firebaseRepository;

  AddPlanUseCase(this._firebaseRepository);

  @override
  Future<void> call({AddPlanData? params}) {
    try {
      return _firebaseRepository.addPlan(params!);
    } catch (e) {
      throw RegisterUserException(e.toString());
    }
  }
}

class RegisterUserException implements Exception {
  final String message;

  RegisterUserException(this.message);
}
