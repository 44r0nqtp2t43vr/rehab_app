import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_patient_numbers.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_state.dart';

class PatientNumbersBloc extends Bloc<PatientNumbersEvent, PatientNumbersState> {
  final GetPatientNumbersUseCase _getPatientNumbersUseCase;

  PatientNumbersBloc(
    this._getPatientNumbersUseCase,
  ) : super(const PatientNumbersLoading()) {
    on<FetchPatientNumbersEvent>(onFetchPatientNumbers);
  }

  void onFetchPatientNumbers(FetchPatientNumbersEvent event, Emitter<PatientNumbersState> emit) async {
    emit(const PatientNumbersLoading());
    try {
      final List<int> patientNumbers = await _getPatientNumbersUseCase(params: event.patientIds);
      emit(PatientNumbersDone(patientNumbers: List.from(patientNumbers)));
    } catch (e) {
      emit(PatientNumbersError(errorMessage: e.toString()));
    }
  }
}
