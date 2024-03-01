import 'dart:ui';

import 'package:rehab_flutter/core/interface/actuators_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class UpdateActuatorsUseCase implements UseCase<void, Offset> {
  final ActuatorsRepository _actuatorsRepository;

  UpdateActuatorsUseCase(this._actuatorsRepository);

  @override
  Future<void> call({Offset? params}) {
    return _actuatorsRepository.updateActuators(params!);
  }
}
