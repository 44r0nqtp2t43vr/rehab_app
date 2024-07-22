import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';
import 'package:rehab_flutter/core/usecases/firebase/get_test_analytics.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/test_analytics/test_analytics_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/test_analytics/test_analytics_state.dart';

class TestAnalyticsBloc extends Bloc<TestAnalyticsEvent, TestAnalyticsState> {
  final GetTestAnalyticsUseCase _getTestAnalyticsUseCase;

  TestAnalyticsBloc(
    this._getTestAnalyticsUseCase,
  ) : super(const TestAnalyticsLoading()) {
    on<FetchTestAnalyticsEvent>(onFetchTestAnalytics);
  }

  void onFetchTestAnalytics(FetchTestAnalyticsEvent event, Emitter<TestAnalyticsState> emit) async {
    emit(const TestAnalyticsLoading());
    try {
      final List<TestingItem> itemsList = await _getTestAnalyticsUseCase(params: event.data);
      itemsList.sort((a, b) => a.itemNumber.compareTo(b.itemNumber));
      emit(TestAnalyticsDone(itemsList: List.from(itemsList)));
    } catch (e) {
      emit(TestAnalyticsError(errorMessage: e.toString()));
    }
  }
}
