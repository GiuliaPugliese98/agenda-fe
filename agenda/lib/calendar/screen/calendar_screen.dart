import 'package:agenda/core/ui/app_routes/routes.dart';
import 'package:agenda/core/ui/app_routes/routes_constants.dart';
import 'package:agenda/core/ui/widgets/text_label_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/enums/text_style_custom_enum.dart';
import '../../core/ui/theme/app_colors.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../../generated/assets.dart';
import '../state/calendar_cubit.dart';
import '../state/calendar_state.dart';

class Calendar extends StatelessWidget {
  final int month;
  final int year;

  Calendar(this.month, this.year, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit(month, year),
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
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return BaseWidget(
      navBarTitle:
          "Calendar - ${DateFormat('MMMM yyyy').format(state.currentMonth)}",
      withOutNavigationBar: false,
      isBackGestureEnabled: true,
      actions: [
        IconButton(
          icon: Image.asset(
            Assets.imagesLeftArrow,
            fit: BoxFit.contain,
            height: 15,
          ),
          onPressed: () => context
              .read<CalendarCubit>()
              .goToPreviousMonth(state.currentMonth),
        ),
        IconButton(
          icon: Image.asset(
            Assets.imagesRightArrow,
            fit: BoxFit.contain,
            height: 15,
          ),
          onPressed: () =>
              context.read<CalendarCubit>().goToNextMonth(state.currentMonth),
        ),
        const Spacer(),
        IconButton(
          icon: Image.asset(
            Assets.imagesLogout,
            fit: BoxFit.contain,
            height: 25,
          ),
          onPressed: () => showLogoutDialog(context, context.read<CalendarCubit>()),
        )
      ],
      body: Column(
        children: [
          // days of the week
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, mainAxisSpacing: 5, mainAxisExtent: 140),
              itemCount: daysInMonth + firstDayOfWeek - 1,
              itemBuilder: (context, index) {
                if (index < firstDayOfWeek - 1) {
                  return Container(); // empty cells (needed for aligment)
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
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.unselected),
                    borderRadius: BorderRadius.circular(25),
                    color: isToday
                        ? AppColors.secondaryColor
                        : AppColors.backgroundColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            "$day",
                            style: TextStyle(
                              fontWeight:
                                  isToday ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Space between date and events
                      // events list
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 70, // to avoid events outside calendar box
                        ),
                        child: ListView.builder(
                          itemCount: eventsForDay.length,
                          itemBuilder: (context, eventIndex) {
                            final event = eventsForDay[eventIndex];
                            return GestureDetector(
                                onTap: () {
                                  AppRoutes.pushNamed(
                                    Routes.eventDetail,
                                    pathParameters: {'uuid': event.uuid},
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: event.createdByLoggedUser
                                        ? AppColors.mainColor
                                        : AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: AppColors.unselected),
                                  ),
                                  child: Text(
                                    event.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: event.createdByLoggedUser
                                          ? AppColors.backgroundColor
                                          : AppColors.blackText,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // cut text if it's too long
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

  Future showLogoutDialog(BuildContext context, CalendarCubit cubit) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextLabelCustom(StringConstants.logoutMessage, align: TextAlign.center, styleEnum: TextStyleCustomEnum.bold),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                CustomButton(
                    filled: true,
                    text: StringConstants.logout,
                    onPressed: () {
                      cubit.logout();
                    }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                CustomButton(
                  text: StringConstants.cancel,
                  filled: false,
                  textColor: AppColors.mainColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
