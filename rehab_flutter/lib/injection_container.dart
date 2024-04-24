import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firestore/logs/logs_bloc.dart';
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
import 'package:rehab_flutter/core/usecases/firebase/add_plan.dart';
import 'package:rehab_flutter/core/usecases/firebase/assign_patient.dart';
import 'package:rehab_flutter/core/usecases/firebase/edit_therapist.dart';
import 'package:rehab_flutter/core/usecases/firebase/edit_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/fetch_login_user_attempt.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_patients.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_therapists.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/logout_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_therapist.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_passive.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_test.dart';
import 'package:rehab_flutter/core/usecases/firebase/log_login_attempt.dart';
import 'package:rehab_flutter/core/usecases/firebase/log_logout_attempt.dart';
import 'package:rehab_flutter/core/usecases/firebase/login_user.dart';
import 'package:rehab_flutter/core/usecases/firebase/register_user.dart';
import 'package:rehab_flutter/core/usecases/actuators/update_actuators.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/connect_device.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/disconnect_device.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/scan_devices.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/update_chara.dart';
import 'package:rehab_flutter/core/usecases/bluetooth/write_data.dart';
import 'package:rehab_flutter/core/usecases/firebase/submit_standard.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dependencies

  sl.registerSingleton<FirebaseRepository>(FirebaseRepositoryImpl(FirebaseFirestore.instance, FirebaseStorage.instance));

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

  sl.registerSingleton<RegisterTherapistUseCase>(RegisterTherapistUseCase(sl()));

  sl.registerSingleton<RegisterUserUseCase>(RegisterUserUseCase(sl()));

  sl.registerSingleton<LoginUserUseCase>(LoginUserUseCase(sl()));

  sl.registerSingleton<AddPlanUseCase>(AddPlanUseCase(sl()));

  sl.registerSingleton<SubmitTestUseCase>(SubmitTestUseCase(sl()));

  sl.registerSingleton<SubmitStandardUseCase>(SubmitStandardUseCase(sl()));

  sl.registerSingleton<SubmitPassiveUseCase>(SubmitPassiveUseCase(sl()));

  sl.registerSingleton<LogoutUserUseCase>(LogoutUserUseCase(sl()));

  sl.registerSingleton<EditUserUseCase>(EditUserUseCase(sl()));

  sl.registerSingleton<EditTherapistUseCase>(EditTherapistUseCase(sl()));

  sl.registerSingleton<AssignPatientUseCase>(AssignPatientUseCase(sl()));

  sl.registerSingleton<GetPatientsUseCase>(GetPatientsUseCase(sl()));

  sl.registerSingleton<GetTherapistsUseCase>(GetTherapistsUseCase(sl()));

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase(sl()));

  // Blocs
  sl.registerFactory<BluetoothBloc>(() => BluetoothBloc(sl(), sl(), sl(), sl(), sl()));

  sl.registerFactory<ActuatorsBloc>(() => ActuatorsBloc(sl(), sl(), sl()));

  sl.registerFactory<UserBloc>(() => UserBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  sl.registerFactory<TherapistBloc>(() => TherapistBloc(sl(), sl(), sl()));

  sl.registerFactory<AdminBloc>(() => AdminBloc(sl()));

  sl.registerFactory<LogsBloc>(() => LogsBloc(sl()));

  sl.registerFactory<PatientListBloc>(() => PatientListBloc(sl(), sl()));

  sl.registerFactory<TherapistListBloc>(() => TherapistListBloc(sl(), sl()));

  sl.registerFactory<ViewedTherapistBloc>(() => ViewedTherapistBloc(sl()));

  sl.registerFactory<ViewedPatientBloc>(() => ViewedPatientBloc());

  sl.registerFactory<TherapistPatientListBloc>(() => TherapistPatientListBloc(sl()));

  sl.registerFactory<ViewedTherapistPatientBloc>(() => ViewedTherapistPatientBloc(sl()));
}
