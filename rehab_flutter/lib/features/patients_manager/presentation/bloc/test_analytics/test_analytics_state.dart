import 'package:equatable/equatable.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';

abstract class TestAnalyticsState extends Equatable {
  final List<TestingItem> itemsList;
  final String? errorMessage;

  const TestAnalyticsState({this.itemsList = const [], this.errorMessage});

  @override
  List<Object> get props => [itemsList];
}

class TestAnalyticsNone extends TestAnalyticsState {
  const TestAnalyticsNone();
}

class TestAnalyticsLoading extends TestAnalyticsState {
  const TestAnalyticsLoading();
}

class TestAnalyticsDone extends TestAnalyticsState {
  const TestAnalyticsDone({List<TestingItem> itemsList = const []}) : super(itemsList: itemsList);
}

class TestAnalyticsError extends TestAnalyticsState {
  const TestAnalyticsError({String? errorMessage}) : super(errorMessage: errorMessage);
}
