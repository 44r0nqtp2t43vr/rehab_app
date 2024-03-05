import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class ConnectDeviceUseCase implements UseCase<List<BluetoothService>, BluetoothDevice> {
  final BluetoothRepository _bluetoothRepository;

  ConnectDeviceUseCase(this._bluetoothRepository);

  @override
  Future<List<BluetoothService>> call({BluetoothDevice? params}) {
    return _bluetoothRepository.connectDevice(params!);
  }
}
