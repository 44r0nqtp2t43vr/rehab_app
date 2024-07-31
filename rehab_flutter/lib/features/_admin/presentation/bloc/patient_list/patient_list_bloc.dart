import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_patients.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_state.dart';

class PatientListBloc extends Bloc<PatientListEvent, PatientListState> {
  final GetPatientsUseCase _getPatientsUseCase;

  PatientListBloc(
    this._getPatientsUseCase,
  ) : super(const PatientListLoading()) {
    on<FetchPatientListEvent>(onFetchPatientList);
    on<UpdatePatientListEvent>(onUpdatePatientList);
  }

  void onFetchPatientList(FetchPatientListEvent event, Emitter<PatientListState> emit) async {
    emit(const PatientListLoading());
    try {
      final List<AppUser> patientList = await _getPatientsUseCase();
      emit(PatientListDone(patientList: patientList));
    } catch (e) {
      emit(PatientListError(errorMessage: e.toString()));
    }
  }

  void onUpdatePatientList(UpdatePatientListEvent event, Emitter<PatientListState> emit) async {
    final index = state.patientList.indexWhere((patient) => patient.userId == event.patientToUpdate!.userId);
    state.patientList[index] = event.patientToUpdate!;
    emit(PatientListDone(patientList: state.patientList));
  }
}
