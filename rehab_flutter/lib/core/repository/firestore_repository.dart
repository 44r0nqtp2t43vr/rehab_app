import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_therapist_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_therapist_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';
import 'package:rehab_flutter/features/tab_profile/domain/entities/edit_user_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseFirestore db;
  final FirebaseStorage storage;

  FirebaseRepositoryImpl(this.db, this.storage);

  @override
  Future<void> logLoginAttempt(String email, bool success) async {
    await db.collection('loginAttempts').add({
      'email': email,
      'success': success,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> logLogoutAttempt(String email, bool success) async {
    await db.collection('logoutAttempts').add({
      'email': email,
      'success': success,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLoginLogs() async {
    final snapshot = await db.collection('loginAttempts').get();
    return snapshot.docs;
  }

  @override
  Future<dynamic> getUser(String userId, {bool isLogin = false}) async {
    // Optionally fetch and do something with the user's document from Firestore
    // For example, retrieving the user's profile information
    DocumentSnapshot<Map<String, dynamic>> userDoc = await db.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      throw Exception('User document does not exist in Firestore.');
    }

    print('Got user with data: ${userDoc.data()}');

    final rolesList = userDoc.data()!['roles'].cast<String>().toList();
    if (rolesList.contains("admin")) {
      final currentAdmin = Admin();
      return currentAdmin;
    } else if (rolesList.contains("therapist")) {
      final patientIds = userDoc.data()!['patients'].cast<String>().toList();

      final List<AppUser> patients = [];
      if (!isLogin) {
        for (var patientId in patientIds) {
          final patientUser = await getUser(patientId);
          patients.add(patientUser);
        }
      }

      // Fetch the download URL of the profile image from Firebase Storage
      String? imageURL = await _getTherapistImageURL(userId);

      print('AAAAAAAA: $imageURL');

      final currentTherapist = Therapist(
        therapistId: userDoc.id,
        firstName: userDoc.data()!['firstName'],
        lastName: userDoc.data()!['lastName'],
        gender: userDoc.data()!['gender'],
        email: userDoc.data()!['email'],
        phoneNumber: userDoc.data()!['phoneNumber'],
        city: userDoc.data()!['city'],
        licenseNumber: userDoc.data()!['licenseNumber'],
        birthDate: userDoc.data()!['birthDate'].toDate() as DateTime,
        registerDate: userDoc.data()!['registerDate'].toDate() as DateTime,
        patientsIds: patientIds,
        patients: patients,
        imageURL: imageURL,
      );

      return currentTherapist;
    } else {
      // Query Plans for the User
      QuerySnapshot<Map<String, dynamic>> plansSnapshot = await db.collection('users').doc(userDoc.id).collection('plans').get();

      List<Plan> plansWithSessions = [];

      for (var planDoc in plansSnapshot.docs) {
        // For each Plan, Query Sessions
        QuerySnapshot<Map<String, dynamic>> sessionsSnapshot = await db.collection('users').doc(userDoc.id).collection('plans').doc(planDoc.id).collection('sessions').get();

        List<Session> sessions = [];
        for (var sessionSnapshotDoc in sessionsSnapshot.docs) {
          // For each session, query testingitems
          QuerySnapshot<Map<String, dynamic>> testingitemsSnapshot = await db.collection('users').doc(userDoc.id).collection('plans').doc(planDoc.id).collection('sessions').doc(sessionSnapshotDoc.id).collection('testingitems').get();
          List<TestingItem> testingitems = testingitemsSnapshot.docs.map((doc) => TestingItem.fromMap(doc.data())).toList();
          Session session = Session.fromMap(sessionSnapshotDoc.data(), items: testingitems);

          sessions.add(session);
        }
        // List<Session> sessions = sessionsSnapshot.docs.map((doc) => Session.fromMap(doc.data())).toList();

        // Combine Plan with its Sessions
        Plan planWithSessions = Plan(
          planId: planDoc.data()['planId'],
          planName: planDoc.data()['planName'],
          startDate: planDoc.data()['startDate'].toDate() as DateTime,
          endDate: planDoc.data()['endDate'].toDate() as DateTime,
          sessions: sessions,
        );

        plansWithSessions.add(planWithSessions);
      }

      // Fetch the download URL of the profile image from Firebase Storage
      String? imageURL = await _getUserImageURL(userId);

      print('AAAAAAAA: $imageURL');

      final currentUser = AppUser(
        userId: userDoc.id,
        firstName: userDoc.data()!['firstName'],
        lastName: userDoc.data()!['lastName'],
        gender: userDoc.data()!['gender'],
        email: userDoc.data()!['email'],
        phoneNumber: userDoc.data()!['phoneNumber'],
        city: userDoc.data()!['city'],
        birthDate: userDoc.data()!['birthDate'].toDate() as DateTime,
        registerDate: userDoc.data()!['registerDate'].toDate() as DateTime,
        conditions: userDoc.data()!['conditions'].cast<String>().toList(),
        plans: plansWithSessions,
        imageURL: imageURL,
      );

      return currentUser;
    }
  }

  Future<String?> _getUserImageURL(String userId) async {
    final storageRef = storage.ref();
    final userImageRef = storageRef.child("images/$userId.jpg");
    try {
      //final downloadURL = await userImageRef.getDownloadURL();
      return await userImageRef.getDownloadURL();
    } catch (e) {
      print('Error getting user image URL: $e');
      return null;
    }
  }

  Future<String?> _getTherapistImageURL(String userId) async {
    final storageRef = storage.ref();
    final userImageRef = storageRef.child("images/$userId.jpg");
    try {
      //final downloadURL = await userImageRef.getDownloadURL();
      return await userImageRef.getDownloadURL();
    } catch (e) {
      print('Error getting Therapist image URL: $e');
      return null;
    }
  }

  @override
  Future<void> registerUser(RegisterData data) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
    String userID = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID

    // Normalize birthDate to just the date part (year, month, day) in UTC
    DateTime birthDateJustDate = DateTime.utc(data.birthDate.year, data.birthDate.month, data.birthDate.day);

    await db.collection('users').doc(userID).set({
      'userID': userID,
      'email': data.email,
      'firstName': data.firstName,
      'lastName': data.lastName,
      'gender': data.gender,
      'phoneNumber': data.phoneNumber,
      'city': data.city,
      'birthDate': birthDateJustDate, // Use the normalized DateTime object
      'registerDate': FieldValue.serverTimestamp(), // Use FieldValue.serverTimestamp() to store the current date and time
      'conditions': data.conditions,
      'roles': ["patient"],
    });
  }

  @override
  Future<void> registerTherapist(RegisterTherapistData data) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
    String userID = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID

    // Normalize birthDate to just the date part (year, month, day) in UTC
    DateTime birthDateJustDate = DateTime.utc(data.birthDate.year, data.birthDate.month, data.birthDate.day);

    await db.collection('users').doc(userID).set({
      'userID': userID,
      'email': data.email,
      'firstName': data.firstName,
      'lastName': data.lastName,
      'gender': data.gender,
      'phoneNumber': data.phoneNumber,
      'city': data.city,
      'licenseNumber': data.licenseNumber,
      'birthDate': birthDateJustDate, // Use the normalized DateTime object
      'registerDate': FieldValue.serverTimestamp(), // Use FieldValue.serverTimestamp() to store the current date and time
      'roles': ["therapist"],
      'patients': [],
    });
  }

  @override
  Future<void> updateCurrentSession(String userId, data) async {
    final DateTime today = DateTime.now();
    final DateTime startOfDay = DateTime(today.year, today.month, today.day);
    final DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Identify the active plan
    final querySnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').where('endDate', isGreaterThanOrEqualTo: endOfDay).limit(1).get();

    final activePlanId = querySnapshot.docs.first.id;

    // Fetch sessions for the current date within the active plan
    final sessionSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').doc(activePlanId).collection('sessions').where('date', isGreaterThanOrEqualTo: startOfDay).where('date', isLessThanOrEqualTo: endOfDay).get();

    // Assuming we update the first session of the day
    final sessionDoc = sessionSnapshot.docs.first;
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').doc(activePlanId).collection('sessions').doc(sessionDoc.id).update(data);
  }

  @override
  Future<void> updateCurrentSessionTesting(String userId, List<TestingItem> items, dynamic data) async {
    final DateTime today = DateTime.now();
    final DateTime startOfDay = DateTime(today.year, today.month, today.day);
    final DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Identify the active plan
    final querySnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').where('endDate', isGreaterThanOrEqualTo: endOfDay).limit(1).get();

    final activePlanId = querySnapshot.docs.first.id;

    // Fetch sessions for the current date within the active plan
    final sessionSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').doc(activePlanId).collection('sessions').where('date', isGreaterThanOrEqualTo: startOfDay).where('date', isLessThanOrEqualTo: endOfDay).get();

    // Assuming we update the first session of the day
    final sessionDoc = sessionSnapshot.docs.first;
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').doc(activePlanId).collection('sessions').doc(sessionDoc.id).update(data);

    for (var item in items) {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').doc(activePlanId).collection('sessions').doc(sessionDoc.id).collection('testingitems').add(item.toMap());
    }
  }

  @override
  Future<dynamic> loginUser(LoginData data) async {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );

    if (userCredential.user == null) {
      throw Exception('User does not exist in FirebaseAuth.');
    }

    // Example of logging the login attempt (success case)
    await logLoginAttempt(data.email, true);

    final dynamic user = await getUser(userCredential.user!.uid, isLogin: true);
    return user;
  }

  @override
  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<AppUser> addPlan(AddPlanData data) async {
    final userId = data.user.userId;

    final DateTime startDate = DateTime.now();
    final DateTime endDate = startDate.add(Duration(days: data.planSelected));

    final plansCollection = FirebaseFirestore.instance.collection('users').doc(userId).collection('plans');
    final int planNumber = (await plansCollection.get()).docs.length + 1;
    final String planDocumentName = 'plan$planNumber';

    List<Session> sessions = [];
    for (int i = 0; i < data.planSelected; i++) {
      DateTime sessionDate = startDate.add(Duration(days: i));
      final String sessionDocumentName = 'session${i + 1}';
      Session session = Session(
        sessionId: sessionDocumentName,
        date: sessionDate,
        standardOneType: '',
        standardOneIntensity: '',
        isStandardOneDone: false,
        passiveIntensity: '',
        isPassiveDone: false,
        standardTwoType: '',
        standardTwoIntensity: '',
        isStandardTwoDone: false,
        pretestScore: null,
        posttestScore: null,
        items: [],
      );
      sessions.add(session);
    }

    // Create the Plan object
    Plan plan = Plan(
      planId: planDocumentName,
      planName: planDocumentName,
      startDate: startDate,
      endDate: endDate,
      sessionCount: data.planSelected,
      isActive: true,
      sessions: sessions,
    );
    await plansCollection.doc(planDocumentName).set({
      'planId': plan.planId,
      'planName': planDocumentName,
      'startDate': plan.startDate,
      'endDate': plan.endDate,
      'session_count': plan.sessionCount,
      'isActive': plan.isActive,
      // Not directly saving sessions here, they will be managed separately.
    }).then((_) async {
      // Create sessions in Firestore under the plan document
      for (int i = 0; i < plan.sessions.length; i++) {
        await plansCollection.doc(planDocumentName).collection('sessions').doc(plan.sessions[i].sessionId).set(plan.sessions[i].toMap()); // Assuming Session class has a toMap method for serialization
      }
    });

    final AppUser user = await getUser(userId);
    return user;
  }

  @override
  Future<AppUser> submitTest(ResultsData data) async {
    if (data.isPretest) {
      final Random random = Random();
      // Creating a list of all StandardTherapy values and shuffling it
      List<StandardTherapy> allTherapies = StandardTherapy.values;
      List<StandardTherapy> shuffledTherapies = List.of(allTherapies)..shuffle(random);

      String standardOneType = shuffledTherapies[0].name;
      String standardTwoType = shuffledTherapies[1].name;
      String intensityLevel = ((data.score / 20).ceil().clamp(1, 5)).toString();

      await updateCurrentSessionTesting(data.user.userId, data.items, {
        'pretestScore': data.score,
        'standardOneType': standardOneType,
        'standardOneIntensity': intensityLevel,
        'standardTwoType': standardTwoType,
        'standardTwoIntensity': intensityLevel,
        'passiveIntensity': intensityLevel,
      });
    } else {
      await updateCurrentSessionTesting(data.user.userId, data.items, {'posttestScore': data.score});
    }

    final AppUser user = await getUser(data.user.userId);
    return user;
  }

  @override
  Future<AppUser> submitStandard(StandardData data) async {
    final dataToSend = data.isStandardOne ? {'isStandardOneDone': true} : {'isStandardTwoDone': true};
    await updateCurrentSession(data.userId, dataToSend);

    final AppUser user = await getUser(data.userId);
    return user;
  }

  @override
  Future<AppUser> submitPassive(String userId) async {
    await updateCurrentSession(userId, {'isPassiveDone': true});

    final AppUser user = await getUser(userId);
    return user;
  }

  @override
  Future<AppUser> editUser(EditUserData data) async {
    // Create a map to store the fields that need to be updated
    Map<String, dynamic> oldFields = data.user.toMap();
    Map<String, dynamic> newFields = data.toMap();
    Map<String, dynamic> fieldsToUpdate = {};

    // Compare the new data with the existing data
    newFields.forEach((key, value) {
      if (key == 'conditions') {
        List<String> oldConditions = oldFields[key];
        List<String> newConditions = newFields[key];
        bool areEqual = oldConditions.length == newConditions.length && List.generate(oldConditions.length, (index) => oldConditions[index] == newConditions[index]).every((element) => element);
        if (!areEqual) {
          fieldsToUpdate[key] = value;
        }
      } else if (oldFields[key] != value) {
        fieldsToUpdate[key] = value;
      }
    });

    if (data.image == null && fieldsToUpdate.isEmpty) {
      return data.user;
    } else {
      if (data.image != null) {
        final storageRef = storage.ref();
        final userImageRef = storageRef.child("images/${data.user.userId}.jpg");
        await userImageRef.putFile(data.image!);
      }
      if (fieldsToUpdate.isNotEmpty) {
        await db.collection('users').doc(data.user.userId).update(fieldsToUpdate);
      }
      final AppUser user = await getUser(data.user.userId);
      return user;
    }
  }

  @override
  Future<Therapist> editTherapist(EditTherapistData data) async {
    // Create a map to store the fields that need to be updated
    Map<String, dynamic> oldFields = data.user.toMap();
    Map<String, dynamic> newFields = data.toMap();
    Map<String, dynamic> fieldsToUpdate = {};

    // Compare the new data with the existing data
    newFields.forEach((key, value) {
      if (oldFields[key] != value) {
        fieldsToUpdate[key] = value;
      }
    });

    if (data.image == null && fieldsToUpdate.isEmpty) {
      return data.user;
    } else {
      if (data.image != null) {
        final storageRef = storage.ref();
        final userImageRef = storageRef.child("images/${data.user.therapistId}.jpg");
        await userImageRef.putFile(data.image!);
      }
      if (fieldsToUpdate.isNotEmpty) {
        await db.collection('users').doc(data.user.therapistId).update(fieldsToUpdate);
      }
      final Therapist user = await getUser(data.user.therapistId);
      return user;
    }
  }

  @override
  Future<Therapist> assignPatient(AssignPatientData data) async {
    final List<String> currentPatients = data.therapist.patientsIds;
    if (data.isAssign) {
      final bool isValidInput = await doesPatientExist(data.patientId);
      if (isValidInput && !currentPatients.contains(data.patientId)) {
        currentPatients.add(data.patientId);
      } else {
        throw Exception();
      }
    } else {
      if (currentPatients.contains(data.patientId)) {
        currentPatients.removeWhere((patientId) => patientId == data.patientId);
      } else {
        throw Exception();
      }
    }

    await db.collection('users').doc(data.therapist.therapistId).update({'patients': currentPatients});

    final Therapist user = await getUser(data.therapist.therapistId);
    return user;
  }

  @override
  Future<bool> doesPatientExist(String userId) async {
    final QuerySnapshot querySnapshot = await db.collection('users').get();
    final List<DocumentSnapshot> documentSnapshots = querySnapshot.docs;

    for (DocumentSnapshot document in documentSnapshots) {
      // Get the data of the document as Map<String, dynamic>
      final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      // Check if the document contains a user with the given userId
      if (data != null && document.id == userId) {
        // Check if the array attribute contains the searchString
        final List<String> roles = data['roles'].cast<String>().toList();
        if (roles.contains("patient")) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  Future<List<String>> getTherapistPatientIds(String therpistId) async {
    DocumentSnapshot<Map<String, dynamic>> therapistDoc = await db.collection('users').doc(therpistId).get();
    return therapistDoc.data()!['patients'].cast<String>().toList();
  }

  @override
  Future<List<String>> getPatientsIds() async {
    final List<String> patientsIds = [];

    final QuerySnapshot querySnapshot = await db.collection('users').get();
    final List<DocumentSnapshot> documentSnapshots = querySnapshot.docs;

    for (DocumentSnapshot document in documentSnapshots) {
      // Get the data of the document as Map<String, dynamic>
      final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      final List<String> roles = data!['roles'].cast<String>().toList();

      if (roles.contains("patient")) {
        patientsIds.add(data['userID']);
      }
    }

    return patientsIds;
  }

  @override
  Future<List<String>> getTherapistsIds() async {
    final List<String> therapistsIds = [];

    final QuerySnapshot querySnapshot = await db.collection('users').get();
    final List<DocumentSnapshot> documentSnapshots = querySnapshot.docs;

    for (DocumentSnapshot document in documentSnapshots) {
      // Get the data of the document as Map<String, dynamic>
      final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      final List<String> roles = data!['roles'].cast<String>().toList();

      if (roles.contains("therapist")) {
        therapistsIds.add(data['userID']);
      }
    }

    return therapistsIds;
  }
}
