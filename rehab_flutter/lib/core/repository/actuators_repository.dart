import 'dart:ui';

import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/interface/actuators_repository.dart';

class ActuatorsRepositoryImpl implements ActuatorsRepository {
  final ActuatorsController _controller;

  ActuatorsRepositoryImpl(this._controller);

  @override
  Future<void> initializeActuators(ActuatorsInitData initData) async {
    await _controller.initializeActuators(orientation: initData.orientation, numOfFingers: initData.numOfFingers, imgSrc: initData.imgSrc, imagesHeight: initData.imagesHeight, imagesWidth: initData.imagesWidth);
  }

  @override
  Future<void> updateActuators(Offset position) {
    _controller.updateActuators(position: position);
    return Future.value(null);
  }

  @override
  Future<void> loadImage(ActuatorsImageData imageData) async {
    _controller.resetActuators();
    await _controller.loadImage(src: imageData.src, preload: imageData.preload);
  }
}
