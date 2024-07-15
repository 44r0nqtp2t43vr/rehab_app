import 'package:rehab_flutter/core/entities/testing_item.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/get_testanalytics_data.dart';

class GetTestAnalyticsUseCase implements UseCase<List<TestingItem>, GetTestAnalyticsData> {
  final FirebaseRepository _firebaseRepository;

  GetTestAnalyticsUseCase(this._firebaseRepository);

  @override
  Future<List<TestingItem>> call({GetTestAnalyticsData? params}) {
    try {
      return _firebaseRepository.getTestAnalytics(params!);
    } catch (e) {
      throw GetTestAnalyticsException(e.toString());
    }
  }
}

class GetTestAnalyticsException implements Exception {
  final String message;

  GetTestAnalyticsException(this.message);
}
