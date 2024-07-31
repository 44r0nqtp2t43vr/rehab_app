import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_therapists.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_state.dart';

class TherapistListBloc extends Bloc<TherapistListEvent, TherapistListState> {
  final GetTherapistsUseCase _getTherapistsUseCase;

  TherapistListBloc(
    this._getTherapistsUseCase,
  ) : super(const TherapistListLoading()) {
    on<FetchTherapistListEvent>(onFetchTherapistList);
    on<UpdateTherapistListEvent>(onUpdateTherapistList);
  }

  void onFetchTherapistList(FetchTherapistListEvent event, Emitter<TherapistListState> emit) async {
    emit(const TherapistListLoading());
    try {
      final List<Therapist> therapistList = await _getTherapistsUseCase();
      emit(TherapistListDone(therapistList: therapistList));
    } catch (e) {
      emit(TherapistListError(errorMessage: e.toString()));
    }
  }

  void onUpdateTherapistList(UpdateTherapistListEvent event, Emitter<TherapistListState> emit) async {
    final index = state.therapistList.indexWhere((therapist) => therapist.therapistId == event.therapistToUpdate!.therapistId);
    state.therapistList[index] = event.therapistToUpdate!;
    emit(TherapistListDone(therapistList: state.therapistList));
  }
}
