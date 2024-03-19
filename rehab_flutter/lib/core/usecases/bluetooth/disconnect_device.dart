import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class DisconnectDeviceUseCase implements UseCase<void, void> {
  final BluetoothRepository _bluetoothRepository;

  DisconnectDeviceUseCase(this._bluetoothRepository);

  @override
  Future<void> call({void params}) {
    return _bluetoothRepository.disconnectDevice();
  }
}
