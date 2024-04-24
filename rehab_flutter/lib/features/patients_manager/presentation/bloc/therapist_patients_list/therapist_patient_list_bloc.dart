import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_state.dart';

class TherapistPatientListBloc extends Bloc<TherapistPatientListEvent, TherapistPatientListState> {
  final GetUserUseCase _getUserUseCase;

  TherapistPatientListBloc(
    this._getUserUseCase,
  ) : super(const TherapistPatientListLoading()) {
    on<FetchTherapistPatientListEvent>(onFetchTherapistPatientList);
  }

  void onFetchTherapistPatientList(FetchTherapistPatientListEvent event, Emitter<TherapistPatientListState> emit) async {
    emit(const TherapistPatientListLoading());
    try {
      final List<AppUser> therapistPatientList = [];
      final List<String> patientIdList = event.therapistPatientsIds!;

      for (var patientId in patientIdList) {
        final patient = await _getUserUseCase(params: patientId);
        therapistPatientList.add(patient);
        emit(const TherapistPatientListLoading());
        emit(TherapistPatientListLoading(therapistPatientList: therapistPatientList));
      }

      emit(TherapistPatientListDone(therapistPatientList: therapistPatientList));
    } catch (e) {
      emit(TherapistPatientListError(errorMessage: e.toString()));
    }
  }

  void onUpdateTherapistPatientList(UpdateTherapistPatientListEvent event, Emitter<TherapistPatientListState> emit) async {
    final index = state.therapistPatientList.indexWhere((patient) => patient.userId == event.patientToUpdate!.userId);
    state.therapistPatientList[index] = event.patientToUpdate!;
    emit(TherapistPatientListDone(therapistPatientList: state.therapistPatientList));
  }
}
