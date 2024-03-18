import 'package:rehab_flutter/core/entities/firebase_model.dart';

abstract class DatabaseRepository {
  Future<void> addNewDocument(Map<String, dynamic> data);
  Stream<List<FireBaseModel>> streamDocuments();
  // Add other Firestore operations
}
