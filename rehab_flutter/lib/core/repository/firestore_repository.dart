import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

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
  Future<void> registerUser(RegisterData data) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;
    String formattedBirthDate = DateFormat('MM/dd/yyyy').format(data.birthDate);

    String userID = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID

    await db.collection('users').doc(userID).set({
      'userID': userID,
      'email': data.email,
      'firstName': data.firstName,
      'lastName': data.lastName,
      'gender': data.gender,
      'phoneNumber': data.phoneNumber,
      'city': data.city,
      'birthDate': formattedBirthDate, // Use the formatted string
      'conditions': data.conditions,
    });
  }

  @override
  Future<AppUser> loginUser(LoginData data) async {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );

    // Example of logging the login attempt (success case)
    await logLoginAttempt(data.email, true);

    // Optionally fetch and do something with the user's document from Firestore
    // For example, retrieving the user's profile information
    DocumentSnapshot<Map<String, dynamic>> userDoc = await db.collection('users').doc(userCredential.user!.uid).get();

    if (!userDoc.exists) {
      throw Exception('User document does not exist in Firestore.');
    }

    print('User logged in with data: ${userDoc.data()}');

    final currentUser = AppUser(
      userId: userDoc.id,
      firstName: userDoc.data()!['firstName'],
      lastName: userDoc.data()!['lastName'],
      gender: userDoc.data()!['gender'],
      email: userDoc.data()!['email'],
      phoneNumber: userDoc.data()!['phoneNumber'],
      city: userDoc.data()!['city'],
      birthDate: DateTime.now(),
      conditions: [],
    );

    return currentUser;
  }
}
