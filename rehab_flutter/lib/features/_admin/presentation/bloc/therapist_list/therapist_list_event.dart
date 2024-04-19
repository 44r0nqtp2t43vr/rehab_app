import 'package:equatable/equatable.dart';

abstract class TherapistListEvent extends Equatable {
  const TherapistListEvent();

  @override
  List<Object> get props => [];
}

class FetchTherapistListEvent extends TherapistListEvent {
  const FetchTherapistListEvent() : super();
}
