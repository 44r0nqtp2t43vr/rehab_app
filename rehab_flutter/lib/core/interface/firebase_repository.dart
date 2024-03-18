// import 'package:rehab_flutter/core/entities/firebase_model.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

abstract class FirebaseRepository {
  Future<void> registerUser(RegisterData data);
  // Future<void> addNewDocument(Map<String, dynamic> data);
  // Stream<List<FireBaseModel>> streamDocuments();
  // Add other Firestore operations
}
