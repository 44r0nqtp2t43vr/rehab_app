import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/pretest_data.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseFirestore db;

  FirebaseRepositoryImpl(this.db);

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
  Future<AppUser> getUser(String userId) async {
    // Optionally fetch and do something with the user's document from Firestore
    // For example, retrieving the user's profile information
    DocumentSnapshot<Map<String, dynamic>> userDoc = await db.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      throw Exception('User document does not exist in Firestore.');
    }

    print('Got user with data: ${userDoc.data()}');

    // Query Plans for the User
    QuerySnapshot<Map<String, dynamic>> plansSnapshot = await db.collection('users').doc(userDoc.id).collection('plans').get();

    List<Plan> plansWithSessions = [];

    for (var planDoc in plansSnapshot.docs) {
      // For each Plan, Query Sessions
      QuerySnapshot<Map<String, dynamic>> sessionsSnapshot = await db.collection('users').doc(userDoc.id).collection('plans').doc(planDoc.id).collection('sessions').get();

      List<Session> sessions = sessionsSnapshot.docs.map((doc) => Session.fromMap(doc.data())).toList();

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
      conditions: [],
      plans: plansWithSessions,
    );

    return currentUser;
  }

  @override
  Future<void> registerUser(RegisterData data) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;

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
    });
  }

  @override
  Future<AppUser> loginUser(LoginData data) async {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );

    if (userCredential.user == null) {
      throw Exception('User does not exist in FirebaseAuth.');
    }

    // Example of logging the login attempt (success case)
    await logLoginAttempt(data.email, true);

    final AppUser user = await getUser(userCredential.user!.uid);
    return user;
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
      );
      sessions.add(session);
    }

    // Create the Plan object
    Plan plan = Plan(
      planId: "plan",
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
  Future<AppUser> submitPretest(PretestData data) async {
    final Random random = Random();
    // Creating a list of all StandardTherapy values and shuffling it
    List<StandardTherapy> allTherapies = StandardTherapy.values;
    List<StandardTherapy> shuffledTherapies = List.of(allTherapies)..shuffle(random);

    String standardOneType = shuffledTherapies[0].name;
    String standardTwoType = shuffledTherapies[1].name;
    final userId = data.user.userId;
    final score = data.score;
    String intensityLevel = ((score / 20).ceil().clamp(1, 5)).toString();

    final DateTime today = DateTime.now();
    final DateTime startOfDay = DateTime(today.year, today.month, today.day);
    final DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Identify the active plan
    final querySnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').where('isActive', isEqualTo: true).limit(1).get();

    final activePlanId = querySnapshot.docs.first.id;

    // Fetch sessions for the current date within the active plan
    final sessionSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').doc(activePlanId).collection('sessions').where('date', isGreaterThanOrEqualTo: startOfDay).where('date', isLessThanOrEqualTo: endOfDay).get();

    // Assuming we update the first session of the day
    final sessionDoc = sessionSnapshot.docs.first;
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('plans').doc(activePlanId).collection('sessions').doc(sessionDoc.id).update({
      'pretestScore': score,
      'standardOneType': standardOneType,
      'standardOneIntensity': intensityLevel,
      'standardTwoType': standardTwoType,
      'standardTwoIntensity': intensityLevel,
      'passiveIntensity': intensityLevel,
    });

    final AppUser user = await getUser(userId);
    return user;
  }
}
