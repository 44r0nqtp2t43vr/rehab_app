import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/resources/data_state.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class ScanDevicesUseCase implements UseCase<DataState<List<BluetoothDevice>>, void> {
  final BluetoothRepository _bluetoothRepository;

  ScanDevicesUseCase(this._bluetoothRepository);

  @override
  Future<DataState<List<BluetoothDevice>>> call({void params}) {
    return _bluetoothRepository.scanDevices();
  }
}
