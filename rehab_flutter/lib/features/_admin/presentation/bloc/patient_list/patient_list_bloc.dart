import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_patients.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_user.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_state.dart';

class PatientListBloc extends Bloc<PatientListEvent, PatientListState> {
  final GetPatientsUseCase _getPatientsUseCase;
  final GetUserUseCase _getUserUseCase;

  PatientListBloc(
    this._getPatientsUseCase,
    this._getUserUseCase,
  ) : super(const PatientListLoading()) {
    on<FetchPatientListEvent>(onFetchPatientList);
  }

  void onFetchPatientList(FetchPatientListEvent event, Emitter<PatientListState> emit) async {
    emit(const PatientListLoading());
    try {
      final List<AppUser> patientList = [];
      final List<String> patientIdList = await _getPatientsUseCase();

      for (var patientId in patientIdList) {
        final patient = await _getUserUseCase(params: patientId);
        patientList.add(patient);
        emit(PatientListLoading(patientList: patientList));
      }

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
