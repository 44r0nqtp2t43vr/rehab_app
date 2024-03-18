import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/logs/logs_bloc.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/interface/actuators_repository.dart';
import 'package:rehab_flutter/core/interface/bluetooth_repository.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/repository/actuators_repository.dart';
import 'package:rehab_flutter/core/repository/bluetooth_repository.dart';
import 'package:rehab_flutter/core/repository/firestore_repository.dart';
import 'package:rehab_flutter/core/usecases/connect_device.dart';
import 'package:rehab_flutter/core/usecases/disconnect_device.dart';
import 'package:rehab_flutter/core/usecases/firebase/FetchLoginLogsUseCase.dart';
import 'package:rehab_flutter/core/usecases/firebase/LogLoginAttemptUseCase.dart';
import 'package:rehab_flutter/core/usecases/firebase/LogLogoutAttemptUseCase.dart';
import 'package:rehab_flutter/core/usecases/init_actuators.dart';
import 'package:rehab_flutter/core/usecases/load_image.dart';
import 'package:rehab_flutter/core/usecases/scan_devices.dart';
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

  sl.registerSingleton<NavigationController>(NavigationController());

  sl.registerSingleton<SongController>(SongController());

  Get.put<NavigationController>(sl());

  Get.put<SongController>(sl());

  // UseCases
  sl.registerSingleton<ScanDevicesUseCase>(ScanDevicesUseCase(sl()));

  sl.registerSingleton<ConnectDeviceUseCase>(ConnectDeviceUseCase(sl()));

  sl.registerSingleton<DisconnectDeviceUseCase>(DisconnectDeviceUseCase(sl()));

  sl.registerSingleton<UpdateCharaUseCase>(UpdateCharaUseCase(sl()));

  sl.registerSingleton<WriteDataUseCase>(WriteDataUseCase(sl()));

  sl.registerSingleton<InitActuatorsUseCase>(InitActuatorsUseCase(sl()));

  sl.registerSingleton<UpdateActuatorsUseCase>(UpdateActuatorsUseCase(sl()));

  sl.registerSingleton<LoadImageUseCase>(LoadImageUseCase(sl()));

  // Blocs
  sl.registerFactory<BluetoothBloc>(
      () => BluetoothBloc(sl(), sl(), sl(), sl(), sl()));

  sl.registerFactory<ActuatorsBloc>(() => ActuatorsBloc(sl(), sl(), sl()));

  sl.registerSingleton<FirebaseInterface>(
      FirebaseRepository(FirebaseFirestore.instance));

  // Register use cases
  sl.registerFactory(() => FetchLoginLogsUseCase(sl()));
  sl.registerFactory(() => LogLoginAttemptUseCase(sl()));
  sl.registerFactory(() => LogLogoutAttemptUseCase(sl()));

  // Register BLoCs with use cases
  sl.registerFactory<LogsBloc>(() => LogsBloc(sl()));
  // Add other BLoCs as needed
}
