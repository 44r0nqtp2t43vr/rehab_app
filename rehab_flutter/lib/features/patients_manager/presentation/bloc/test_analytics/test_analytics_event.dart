import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/get_testanalytics_data.dart';

abstract class TestAnalyticsEvent extends Equatable {
  final GetTestAnalyticsData? data;

  const TestAnalyticsEvent({this.data});

  @override
  List<Object> get props => [data!];
}

class FetchTestAnalyticsEvent extends TestAnalyticsEvent {
  const FetchTestAnalyticsEvent(GetTestAnalyticsData data) : super(data: data);
}
