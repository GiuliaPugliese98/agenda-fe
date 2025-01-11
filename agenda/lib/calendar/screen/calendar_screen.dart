import 'package:agenda/core/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, CalendarLoaded state) {
    final daysInMonth = DateTime(
        state.currentMonth.year, state.currentMonth.month + 1, 0).day;
    final firstDayOfWeek = DateTime(
        state.currentMonth.year, state.currentMonth.month, 1).weekday;
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Calendar - ${DateFormat('MMMM yyyy').format(state.currentMonth)}"),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back), //TODO devo caricare immagine
            onPressed: () => context.read<CalendarCubit>().goToPreviousMonth(
                state.currentMonth),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward), //TODO devo caricare immagine
            onPressed: () =>
                context.read<CalendarCubit>().goToNextMonth(state.currentMonth),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7),
              itemCount: daysInMonth + firstDayOfWeek - 1,
              itemBuilder: (context, index) {
                if (index < firstDayOfWeek - 1) {
                  return Container(); // Empty cells for alignment
                }

                final day = index - firstDayOfWeek + 2;
                final date = DateTime(
                    state.currentMonth.year, state.currentMonth.month, day);
                final isToday = date.year == today.year &&
                    date.month == today.month && date.day == today.day;
                final eventsForDay = state.events.where((event) =>
                event.startDate == date).toList();

                return GestureDetector(
                  onTap: () {
                    // TODO: Show event details popup
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.tabBarUnselected),
                      color: isToday ?  AppColors.secondaryColor :  AppColors.backgroundColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$day",
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight
                                .normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE').format(date),
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight
                                .normal,
                            fontSize: 14,
                            color: isToday ? AppColors.mainColor : AppColors.blackText,
                          ),
                        ),
                        ...eventsForDay.map((event) =>
                            Text(
                              event.title,
                              style: TextStyle(
                                color: event.isUserEvent ? AppColors.mainColor: AppColors.blackText,
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

  class CalendarEventModel {
  final String title;
  final DateTime date;
  final bool isUserEvent;

  CalendarEventModel({required this.title, required this.date, this.isUserEvent = false});
}