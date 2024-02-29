import 'package:get_it/get_it.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/core/interface/actuators_repository.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/repository/actuators_repository.dart';
import 'package:rehab_flutter/core/repository/bluetooth_repository.dart';
import 'package:rehab_flutter/core/usecases/init_actuators.dart';
import 'package:rehab_flutter/core/usecases/update_actuators.dart';
import 'package:rehab_flutter/core/usecases/update_chara.dart';
import 'package:rehab_flutter/core/usecases/write_data.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dependencies

  sl.registerSingleton<BluetoothController>(BluetoothController());

  sl.registerSingleton<BluetoothRepository>(BluetoothRepositoryImpl(sl()));

  sl.registerSingleton<ActuatorsController>(ActuatorsController());

  sl.registerSingleton<ActuatorsRepository>(ActuatorsRepositoryImpl(sl()));

  // UseCases
  sl.registerSingleton<UpdateCharaUseCase>(UpdateCharaUseCase(sl()));

  sl.registerSingleton<WriteDataUseCase>(WriteDataUseCase(sl()));

  sl.registerSingleton<InitActuatorsUseCase>(InitActuatorsUseCase(sl()));

  sl.registerSingleton<UpdateActuatorsUseCase>(UpdateActuatorsUseCase(sl()));

  // Blocs
  sl.registerFactory<BluetoothBloc>(() => BluetoothBloc(sl(), sl()));

  sl.registerFactory<ActuatorsBloc>(() => ActuatorsBloc(sl(), sl()));
}
