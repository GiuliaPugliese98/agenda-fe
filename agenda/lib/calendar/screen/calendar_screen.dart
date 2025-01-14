import 'package:agenda/core/ui/app_routes/routes.dart';
import 'package:agenda/core/ui/app_routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/ui/theme/app_colors.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../state/calendar_cubit.dart';
import '../state/calendar_state.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit(),
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          if (state is CalendarLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CalendarLoaded) {
            return _buildCalendar(context, state);
          } else if (state is CalendarError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text(StringConstants.noData));
          }
        },
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, CalendarLoaded state) {
    final daysInMonth =
        DateTime(state.currentMonth.year, state.currentMonth.month + 1, 0).day;
    final firstDayOfWeek =
        DateTime(state.currentMonth.year, state.currentMonth.month, 1).weekday;
    final today = DateTime.now();
    return BaseWidget(
      navBarTitle:
          "Calendar - ${DateFormat('MMMM yyyy').format(state.currentMonth)}",
      withOutNavigationBar: false,
      isBackGestureEnabled: true,
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context
              .read<CalendarCubit>()
              .goToPreviousMonth(state.currentMonth),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () =>
              context.read<CalendarCubit>().goToNextMonth(state.currentMonth),
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemCount: daysInMonth + firstDayOfWeek - 1,
              itemBuilder: (context, index) {
                if (index < firstDayOfWeek - 1) {
                  return Container(); // Celle vuote per allineamento
                }
                final day = index - firstDayOfWeek + 2;
                final date = DateTime(
                    state.currentMonth.year, state.currentMonth.month, day);
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                final eventsForDay = state.events
                    .where((event) => isSameDay(event.startDate, date))
                    .toList();
                return Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.unselected),
                    color: isToday
                        ? AppColors.secondaryColor
                        : AppColors.backgroundColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            "$day",
                            style: TextStyle(
                              fontWeight:
                                  isToday ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('EEEE').format(date),
                            style: TextStyle(
                              fontWeight:
                                  isToday ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                              color: isToday
                                  ? AppColors.mainColor
                                  : AppColors.blackText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Spazio tra data e eventi
                      // Lista di eventi da qui
                      Expanded(
                        child: ListView.builder(
                          itemCount: eventsForDay.length,
                          itemBuilder: (context, eventIndex) {
                            final event = eventsForDay[eventIndex];
                            return GestureDetector(
                                onTap: () {
                                  AppRoutes.pushNamed(Routes.eventDetail,
                                      arguments: {
                                        StringConstants.eventDetailsKey:
                                            eventsForDay[eventIndex].uuid
                                      });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: event.createdByLoggedUser
                                        ? AppColors.mainColor.withOpacity(0.1)
                                        : AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: AppColors.unselected),
                                  ),
                                  child: Text(
                                    event.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.blackText,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Mi serve per tagliare il testo se troppo lungo
                                    maxLines: 1,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: StringConstants.addEvent,
              onPressed: () {
                AppRoutes.pushNamed(Routes.addEvent);
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
