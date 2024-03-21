// import 'package:rehab_flutter/core/interface/firestore_repository.dart';
// import 'package:rehab_flutter/core/usecase/usecase.dart';
// import 'package:rehab_flutter/features/pre_test_dummy/pretest_session_generation_data.dart';

// class GenerateSessionUseCase implements UseCase<void, PretestData> {
//   final FirebaseRepository _firebaseRepository;

//   GenerateSessionUseCase(this._firebaseRepository);

//   @override
//   Future<void> call({PretestData? params}) {
//     try {
//       return _firebaseRepository.generateSession(params!);
//     } catch (e) {
//       throw RegisterUserException(e.toString());
//     }
//   }
// }

// class RegisterUserException implements Exception {
//   final String message;

//   RegisterUserException(this.message);
// }
