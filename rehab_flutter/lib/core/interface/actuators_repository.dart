import 'dart:ui';

import 'package:rehab_flutter/core/entities/actuators_initdata.dart';

abstract class ActuatorsRepository {
  // API methods
  Future<void> initializeActuators(ActuatorsInitData initData);
  Future<void> updateActuators(Offset position);
}
