import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class ScanDevicesUseCase implements UseCase<Stream<List<ScanResult>>, void> {
  final BluetoothRepository _bluetoothRepository;

  ScanDevicesUseCase(this._bluetoothRepository);

  @override
  Future<Stream<List<ScanResult>>> call({void params}) {
    return _bluetoothRepository.scanDevices();
  }
}
