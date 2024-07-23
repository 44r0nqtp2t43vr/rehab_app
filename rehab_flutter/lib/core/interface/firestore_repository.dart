import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/patient_sessions.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_therapist_data.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/delete_plan_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_therapist_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/get_testanalytics_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';
import 'package:rehab_flutter/features/tab_profile/domain/entities/edit_user_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

abstract class FirebaseRepository {
  Future<void> logLoginAttempt(String email, bool success);
  Future<void> logLogoutAttempt(String email, bool success);
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLoginLogs();
  Future<dynamic> getUser(String userId);
  Future<dynamic> getUserDetails(String userId);
  Future<void> registerUser(RegisterData data);
  Future<void> registerTherapist(RegisterTherapistData data);
  Future<void> updateCurrentSession(String userId, dynamic data);
  Future<void> updateCurrentSessionTesting(String userId, List<TestingItem> items, dynamic data);
  Future<AppUser> addPlan(AddPlanData data);
  Future<void> deletePlan(DeletePlanData data);
  Future<Session> submitTest(ResultsData data);
  Future<Session> submitStandard(StandardData data);
  Future<Session> submitPassive(PassiveData data);
  Future<Session> resetSession(PassiveData data);
  Future<dynamic> loginUser(LoginData data);
  Future<void> logoutUser();
  Future<AppUser> editUser(EditUserData data);
  Future<void> editUserSession(EditSessionData data);
  Future<Therapist> editTherapist(EditTherapistData data);
  Future<void> assignPatient(AssignPatientData data);
  Future<bool> doesPatientExist(String userId);
  Future<List<String>> getTherapistPatientIds(String therapistId);
  Future<List<String>> getPatientsIds();
  Future<List<String>> getTherapistsIds();
  Future<List<Plan>> fetchPatientPlans(String patientId);
  Future<Plan> fetchPatientCurrentPlan(String patientId);
  Future<Session> fetchPatientCurrentSession(String patientId);
  Future<List<Plan>> getPatientPlansList(String patientId);
  Future<List<Session>> getPatientPlanSessionsList(PatientPlan patientPlan);
  Future<List<TestingItem>> getTestAnalytics(GetTestAnalyticsData data);
  Future<List<int>> getPatientNumbers(List<String> patientIds);
  Future<List<PatientSessions>> getTherapistPatientListSessions(List<String> patientIds);
  Future<List<AppUser>> getAllPatients();
}
