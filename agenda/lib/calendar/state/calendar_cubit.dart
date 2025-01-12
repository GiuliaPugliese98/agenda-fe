import 'package:agenda/core/data/repository/user_repository.dart';
import 'package:get/get.dart';

import '../../core/bloc/base_cubit.dart';
import '../../core/data/repository/event_repository.dart';
import 'calendar_state.dart';

class CalendarCubit extends BaseCubit<CalendarState> {
  final EventRepository eventRepository = Get.find<EventRepository>();
  final UserRepository userRepository = Get.find<UserRepository>();

  CalendarCubit() : super(CalendarInit()) {
    loadEventsForMonth(DateTime.now());
  }

  void loadEventsForMonth(DateTime month) async {
    emit(CalendarLoading());
    try {
      final events = await eventRepository.getAllEvents(); //TODO per mese!
      final user = await userRepository.getUser();
      emit(CalendarLoaded(events: events, currentMonth: month));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  void goToNextMonth(DateTime currentMonth) {
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    loadEventsForMonth(nextMonth);
  }

  void goToPreviousMonth(DateTime currentMonth) {
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    loadEventsForMonth(previousMonth);
  }
}