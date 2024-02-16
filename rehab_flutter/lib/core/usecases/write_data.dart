import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class WriteDataUseCase implements UseCase<void, String?> {
  final BluetoothRepository _bluetoothRepository;

  WriteDataUseCase(this._bluetoothRepository);

  @override
  Future<void> call({String? params}) {
    return _bluetoothRepository.writeData(params!);
  }
}
