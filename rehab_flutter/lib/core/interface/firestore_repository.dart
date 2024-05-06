import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_therapist_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_therapist_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';
import 'package:rehab_flutter/features/tab_profile/domain/entities/edit_user_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

abstract class FirebaseRepository {
  Future<void> logLoginAttempt(String email, bool success);
  Future<void> logLogoutAttempt(String email, bool success);
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLoginLogs();
  Future<dynamic> getUser(String userId);
  Future<void> registerUser(RegisterData data);
  Future<void> registerTherapist(RegisterTherapistData data);
  Future<void> updateCurrentSession(String userId, dynamic data);
  Future<void> updateCurrentSessionTesting(String userId, List<TestingItem> items, dynamic data);
  Future<AppUser> addPlan(AddPlanData data);
  Future<AppUser> submitTest(ResultsData data);
  Future<AppUser> submitStandard(StandardData data);
  Future<AppUser> submitPassive(String userId);
  Future<dynamic> loginUser(LoginData data);
  Future<void> logoutUser();
  Future<AppUser> editUser(EditUserData data);
  Future<AppUser> editUserSession(EditSessionData data);
  Future<Therapist> editTherapist(EditTherapistData data);
  Future<Therapist> assignPatient(AssignPatientData data);
  Future<bool> doesPatientExist(String userId);
  Future<List<String>> getTherapistPatientIds(String therapistId);
  Future<List<String>> getPatientsIds();
  Future<List<String>> getTherapistsIds();
}
