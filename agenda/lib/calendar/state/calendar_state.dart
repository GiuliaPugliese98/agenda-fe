import '../../core/bloc/base_state.dart';
import '../../core/data/models/event_model/event_model.dart';

class CalendarState extends BaseState {
}

class CalendarInit extends CalendarState {
}

class CalendarLoading extends CalendarState {
}

class CalendarLoaded extends CalendarState {
  final List<EventModel> events;
  final DateTime currentMonth;

  CalendarLoaded({required this.events, required this.currentMonth});

  @override
  List<Object?> get props => [events, currentMonth];
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}
