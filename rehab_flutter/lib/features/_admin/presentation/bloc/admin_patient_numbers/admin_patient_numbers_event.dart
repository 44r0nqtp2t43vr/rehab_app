import 'package:equatable/equatable.dart';

abstract class AdminPatientNumbersEvent extends Equatable {
  // final List<String> patientIds;

  const AdminPatientNumbersEvent();

  @override
  List<Object> get props => [];
}

class FetchAdminPatientNumbersEvent extends AdminPatientNumbersEvent {
  const FetchAdminPatientNumbersEvent() : super();
}
