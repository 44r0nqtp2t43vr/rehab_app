import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';

abstract class ActuatorsEvent extends Equatable {
  final ActuatorsInitData? initData;
  final ActuatorsImageData? imageData;
  final Offset? offset;

  const ActuatorsEvent({this.initData, this.imageData, this.offset});

  @override
  List<Object> get props => [initData!, offset!];
}

class InitActuatorsEvent extends ActuatorsEvent {
  const InitActuatorsEvent(ActuatorsInitData initData) : super(initData: initData);
}

class UpdateActuatorsEvent extends ActuatorsEvent {
  const UpdateActuatorsEvent(Offset offset) : super(offset: offset);
}

class LoadImageEvent extends ActuatorsEvent {
  const LoadImageEvent(ActuatorsImageData imageData) : super(imageData: imageData);
}
