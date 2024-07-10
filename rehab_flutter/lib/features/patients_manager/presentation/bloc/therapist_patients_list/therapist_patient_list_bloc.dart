import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_therapist_patient_ids.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_user_details.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_state.dart';

class TherapistPatientListBloc extends Bloc<TherapistPatientListEvent, TherapistPatientListState> {
  final GetUserDetailsUseCase _getUserDetailsUseCase;
  final GetTherapistPatientIdsUseCase _getTherapistPatientIdsUseCase;

  TherapistPatientListBloc(
    this._getUserDetailsUseCase,
    this._getTherapistPatientIdsUseCase,
  ) : super(const TherapistPatientListLoading()) {
    on<ResetTherapistPatientListEvent>(onResetTherapistPatientListEvent);
    on<FetchTherapistPatientListEvent>(onFetchTherapistPatientList);
    on<AddTherapistPatientListEvent>(onAddTherapistPatientList);
    on<RemoveTherapistPatientListEvent>(onRemoveTherapistPatientList);
    on<UpdateTherapistPatientListEvent>(onUpdateTherapistPatientList);
  }

  void onResetTherapistPatientListEvent(ResetTherapistPatientListEvent event, Emitter<TherapistPatientListState> emit) async {
    emit(const TherapistPatientListLoading());
  }

  void onFetchTherapistPatientList(FetchTherapistPatientListEvent event, Emitter<TherapistPatientListState> emit) async {
    emit(const TherapistPatientListLoading());
    try {
      final List<AppUser> therapistPatientList = [];
      // final List<String> patientIdList = event.therapistPatientsIds!;
      final List<String> patientIdList = await _getTherapistPatientIdsUseCase(params: event.therapistId);

      for (var patientId in patientIdList) {
        final patient = await _getUserDetailsUseCase(params: patientId);
        therapistPatientList.add(patient);
        emit(const TherapistPatientListLoading());
        emit(TherapistPatientListLoading(therapistPatientList: therapistPatientList));
      }

      emit(TherapistPatientListDone(therapistPatientList: therapistPatientList));
    } catch (e) {
      emit(TherapistPatientListError(errorMessage: e.toString()));
    }
  }

  void onAddTherapistPatientList(AddTherapistPatientListEvent event, Emitter<TherapistPatientListState> emit) async {
    state.therapistPatientList.add(event.patientToUpdate!);
    emit(TherapistPatientListDone(therapistPatientList: state.therapistPatientList));
  }

  void onRemoveTherapistPatientList(RemoveTherapistPatientListEvent event, Emitter<TherapistPatientListState> emit) async {
    state.therapistPatientList.remove(event.patientToUpdate!);
    emit(TherapistPatientListDone(therapistPatientList: state.therapistPatientList));
  }

  void onUpdateTherapistPatientList(UpdateTherapistPatientListEvent event, Emitter<TherapistPatientListState> emit) async {
    final index = state.therapistPatientList.indexWhere((patient) => patient.userId == event.patientToUpdate!.userId);
    state.therapistPatientList[index] = event.patientToUpdate!;
    emit(TherapistPatientListDone(therapistPatientList: state.therapistPatientList));
  }
}
