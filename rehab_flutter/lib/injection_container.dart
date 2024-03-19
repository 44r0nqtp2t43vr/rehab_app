import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';

import 'package:rehab_flutter/core/bloc/firebase/logs/logs_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
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
import 'package:rehab_flutter/core/usecases/actuators/init_actuators.dart';
import 'package:rehab_flutter/core/usecases/actuators/load_image.dart';
import 'package:rehab_flutter/core/usecases/firebase/login_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_user.dart';
import 'package:rehab_flutter/core/usecases/actuators/update_actuators.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/connect_device.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/disconnect_device.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/scan_devices.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/update_chara.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/write_data.dart';
import 'package:rehab_flutter/core/usecases/firebase/FetchLoginLogsUseCase.dart';
import 'package:rehab_flutter/core/usecases/firebase/LogLoginAttemptUseCase.dart';
import 'package:rehab_flutter/core/usecases/firebase/LogLogoutAttemptUseCase.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dependencies

  sl.registerSingleton<FirebaseRepository>(
      FirebaseRepositoryImpl(FirebaseFirestore.instance));

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

  sl.registerSingleton<FetchLoginLogsUseCase>(FetchLoginLogsUseCase(sl()));

  sl.registerSingleton<LogLoginAttemptUseCase>(LogLoginAttemptUseCase(sl()));

  sl.registerSingleton<LogLogoutAttemptUseCase>(LogLogoutAttemptUseCase(sl()));

  sl.registerSingleton<RegisterUserUseCase>(RegisterUserUseCase(sl()));

  sl.registerSingleton<LoginUserUseCase>(LoginUserUseCase(sl()));

  // Blocs
  sl.registerFactory<BluetoothBloc>(
      () => BluetoothBloc(sl(), sl(), sl(), sl(), sl()));

  sl.registerFactory<ActuatorsBloc>(() => ActuatorsBloc(sl(), sl(), sl()));

  sl.registerFactory<UserBloc>(() => UserBloc(sl(), sl()));

  sl.registerFactory<LogsBloc>(() => LogsBloc(sl()));
}
