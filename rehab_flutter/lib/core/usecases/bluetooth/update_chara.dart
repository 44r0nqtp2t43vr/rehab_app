import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class UpdateCharaUseCase implements UseCase<void, BluetoothCharacteristic> {
  final BluetoothRepository _bluetoothRepository;

  UpdateCharaUseCase(this._bluetoothRepository);

  @override
  Future<void> call({BluetoothCharacteristic? params}) {
    return _bluetoothRepository.updateCharacteristic(params!);
  }
}
