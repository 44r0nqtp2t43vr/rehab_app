import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/interface/actuators_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class InitActuatorsUseCase implements UseCase<void, ActuatorsInitData> {
  final ActuatorsRepository _actuatorsRepository;

  InitActuatorsUseCase(this._actuatorsRepository);

  @override
  Future<void> call({ActuatorsInitData? params}) {
    return _actuatorsRepository.initializeActuators(params!);
  }
}
