import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_admin_patient_numbers.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/admin_patient_numbers/admin_patient_numbers_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/admin_patient_numbers/admin_patient_numbers_state.dart';

class AdminPatientNumbersBloc extends Bloc<AdminPatientNumbersEvent, AdminPatientNumbersState> {
  final GetAdminPatientNumbersUseCase _getAdminPatientNumbersUseCase;

  AdminPatientNumbersBloc(
    this._getAdminPatientNumbersUseCase,
  ) : super(const AdminPatientNumbersLoading()) {
    on<FetchAdminPatientNumbersEvent>(onFetchAdminPatientNumbers);
  }

  void onFetchAdminPatientNumbers(FetchAdminPatientNumbersEvent event, Emitter<AdminPatientNumbersState> emit) async {
    emit(const AdminPatientNumbersLoading());
    try {
      final List<int> patientNumbers = await _getAdminPatientNumbersUseCase();
      emit(AdminPatientNumbersDone(patientNumbers: List.from(patientNumbers)));
    } catch (e) {
      emit(AdminPatientNumbersError(errorMessage: e.toString()));
    }
  }
}
