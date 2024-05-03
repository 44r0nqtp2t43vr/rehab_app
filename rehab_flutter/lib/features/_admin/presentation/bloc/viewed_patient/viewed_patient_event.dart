import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';

abstract class ViewedPatientEvent extends Equatable {
  final AppUser? currentPatient;
  final AddPlanData? addPlanData;

  const ViewedPatientEvent({this.currentPatient, this.addPlanData});

  @override
  List<Object> get props => [currentPatient!];
}

class FetchViewedPatientEvent extends ViewedPatientEvent {
  const FetchViewedPatientEvent(AppUser currentPatient) : super(currentPatient: currentPatient);
}

class AddPatientPlanEvent extends ViewedPatientEvent {
  const AddPatientPlanEvent(AddPlanData addPlanData) : super(addPlanData: addPlanData);
}
