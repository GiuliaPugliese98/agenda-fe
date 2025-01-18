import 'package:agenda/core/data/repository/user_repository.dart';
import 'package:get/get.dart';

import '../../core/bloc/base_cubit.dart';
import '../../core/data/repository/event_repository.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';
import 'calendar_state.dart';

class CalendarCubit extends BaseCubit<CalendarState> {
  final EventRepository eventRepository = Get.find<EventRepository>();

  CalendarCubit(int month, int year) : super(CalendarInit()) {
    DateTime selectedDate = DateTime(year, month);
    loadEventsForMonth(selectedDate);
  }

  void loadEventsForMonth(DateTime month) async {
    emit(CalendarLoading());
    try {
      final events = await eventRepository.getAllEvents(); //TODO per mese!
      emit(CalendarLoaded(events: events, currentMonth: month));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  void goToNextMonth(DateTime currentMonth) {
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    String month = nextMonth.month.toString();
    String year = nextMonth.year.toString();
    AppRoutes.pushNamed(
      Routes.calendar,
      pathParameters: {'month': month, 'year': year},
    );
  }

  void goToPreviousMonth(DateTime currentMonth) {
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    String month = previousMonth.month.toString();
    String year = previousMonth.year.toString();
    AppRoutes.pushNamed(
      Routes.calendar,
      pathParameters: {'month': month, 'year': year},
    );
  }
}