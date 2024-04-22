import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/main/admin_main.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/patient_page/admin_patient_page.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/therapist_page/admin_therapist_page.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/bluetooth_connect/bluetooth_connect_screen.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/bluetooth_screen/bluetooth_screen.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/main_screen/main_screen.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/service_screen/service_screen.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/login/login_screen.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/register/register_screen.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/register_therapist/register_therapist.dart';
import 'package:rehab_flutter/features/logs_screen/presentation/logs_screen.dart';
import 'package:rehab_flutter/features/passive_therapy/presenation/passive_therapy_screen.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/assign_patients/assign_patients.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/edit_therapist_profile/edit_therapist_profile.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/patient_page/patient_page.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/patient_plan_details/patient_plan_details.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/therapist_main/therapist_main.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/pages/play_game/play_game.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/pages/actuator_therapy_screen.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/pages/pattern_therapy_screen.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_therapy_data.dart';
import 'package:rehab_flutter/features/standard_therapy/presentation/pages/standard_therapy_screen/standard_therapy_screen.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/pages/edit_profile/edit_profile.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/pages/user_qr/user_qr.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/pages/texture_therapy/texture_therapy.dart';
import 'package:rehab_flutter/features/scrolling_textures/presentation/pages/scroll_textures/scroll_textures.dart';
import 'package:rehab_flutter/features/testing/presentation/screens/testing_screen/testing_screen.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/screens/visualizer_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const OnboardingScreen());

      case '/Onboarding':
        return _materialRoute(const OnboardingScreen());

      case '/Login':
        return _materialRoute(const LoginScreen());

      case '/Register':
        return _materialRoute(const RegisterScreen());

      case '/RegisterTherapist':
        return _materialRoute(const RegisterTherapist());

      case '/BluetoothConnect':
        return _materialRoute(const BluetoothConnectScreen());

      case '/BluetoothScreen':
        return _materialRoute(const BluetoothScreen());

      case '/ServiceScreen':
        return _materialRoute(
            ServiceScreen(targetDevice: settings.arguments as BluetoothDevice));

      case '/MainScreen':
        return _materialRoute(const MainScreen());

      case '/Testing':
        return _materialRoute(
            TestingScreen(isPretest: settings.arguments as bool));

      case '/PlayGame':
        return _materialRoute(PlayGame(
          song: sl<SongController>().getCurrentSong()!,
          startingNoteIndex: sl<SongController>().getCurrentDuration() ~/ 0.3,
        ));

      case '/ActuatorTherapy':
        return _materialRoute(const ActuatorTherapy());

      case '/PatternTherapy':
        return _materialRoute(const PatternTherapy());

      case '/TextureTherapy':
        return _materialRoute(const TextureTherapy());

      case '/LogsScreen':
        return _materialRoute(const LogsScreen());

      case '/ScrollTextures':
        return _materialRoute(const ScrollTextures());

      case '/VisualizerScreen':
        return _materialRoute(VisualizerScreenSlider(
          songData: sl<SongController>().getCurrentSong()!,
          currentPositionSec: sl<SongController>().getCurrentDuration(),
        ));

      case '/StandardTherapy':
        return _materialRoute(StandardTherapyScreen(
            data: settings.arguments as StandardTherapyData));

      case '/PassiveTherapy':
        return _materialRoute(
            PassiveTherapyScreen(userId: settings.arguments as String));

      case '/EditProfile':
        return _materialRoute(EditProfile(user: settings.arguments as AppUser));

      case '/UserQR':
        return _materialRoute(const UserQR());

      case '/TherapistMain':
        return _materialRoute(const TherapistMainScreen());

      case '/AssignPatients':
        return _materialRoute(const AssignPatients());

      case '/PatientPage':
        return _materialRoute(
            PatientPage(patient: settings.arguments as AppUser));

      case '/PatientPlanDetails':
        return _materialRoute(
            PatientPlanDetails(plan: settings.arguments as Plan));

      case '/EditTherapistProfile':
        return _materialRoute(
            EditTherapistProfile(user: settings.arguments as Therapist));

      case '/AdminMain':
        return _materialRoute(const AdminMainScreen());

      case '/AdminPatientPage':
        return _materialRoute(
            AdminPatientPage(patient: settings.arguments as AppUser));

      case '/AdminTherapistPage':
        return _materialRoute(AdminTherapistPage(therapist: settings.arguments as Therapist));

      default:
        return _materialRoute(const OnboardingScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view, maintainState: false);
  }
}
