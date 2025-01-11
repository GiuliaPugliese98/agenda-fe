import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final daysInMonth = DateTime(state.currentMonth.year, state.currentMonth.month + 1, 0).day;
    final firstDayOfWeek = DateTime(state.currentMonth.year, state.currentMonth.month, 1).weekday;
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar - ${state.currentMonth.year}-${state.currentMonth.month}"),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.read<CalendarCubit>().goToPreviousMonth(state.currentMonth),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => context.read<CalendarCubit>().goToNextMonth(state.currentMonth),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemCount: daysInMonth + firstDayOfWeek - 1,
        itemBuilder: (context, index) {
          if (index < firstDayOfWeek - 1) {
            return Container();
          }

          final day = index - firstDayOfWeek + 2;
          final date = DateTime(state.currentMonth.year, state.currentMonth.month, day);
          final eventsForDay = state.events.where((event) => event.startDate == date).toList();

          return GestureDetector(
            onTap: () {
              // TODO: Show event details popup
            },
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: date == today ? Colors.yellow : Colors.white,
              ),
              child: Column(
                children: [
                  Text("$day"),
                  ...eventsForDay.map((event) => Text(
                    event.title,
                    style: TextStyle(
                      color: event.isUserEvent ? Colors.blue : Colors.black,
                    ),
                  )),
                ],
              ),
            ),
          );
        },
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