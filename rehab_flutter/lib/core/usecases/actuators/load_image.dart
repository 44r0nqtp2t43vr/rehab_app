import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/interface/actuators_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class LoadImageUseCase implements UseCase<void, ActuatorsImageData> {
  final ActuatorsRepository _actuatorsRepository;

  LoadImageUseCase(this._actuatorsRepository);

  @override
  Future<void> call({ActuatorsImageData? params}) {
    return _actuatorsRepository.loadImage(params!);
  }
}
