import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/core/usecase/usecase.dart';

class FetchLoginLogsUseCase extends UseCase<List<QueryDocumentSnapshot<Map<String, dynamic>>>, NoParams> {
  final FirebaseRepository _repository;

  FetchLoginLogsUseCase(this._repository);

  @override
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> call({NoParams? params}) async {
    return await _repository.getLoginLogs();
  }
}
