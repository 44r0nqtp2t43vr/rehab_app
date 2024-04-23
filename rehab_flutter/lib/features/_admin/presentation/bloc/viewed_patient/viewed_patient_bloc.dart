import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_state.dart';

class ViewedPatientBloc extends Bloc<ViewedPatientEvent, ViewedPatientState> {
  // final AssignPatientUseCase _assignPatientUseCase;

  ViewedPatientBloc(
      // this._assignPatientUseCase,
      )
      : super(const ViewedPatientLoading()) {
    on<FetchViewedPatientEvent>(onFetchViewedPatient);
  }

  void onFetchViewedPatient(FetchViewedPatientEvent event, Emitter<ViewedPatientState> emit) async {
    if (event.currentPatient != null) {
      emit(ViewedPatientDone(patient: event.currentPatient));
    }
  }
}
