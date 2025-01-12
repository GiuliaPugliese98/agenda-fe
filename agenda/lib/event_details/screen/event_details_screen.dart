import 'package:agenda/core/data/models/user_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/data/models/event_model/event_model.dart';
import '../../core/enums/text_style_custom_enum.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../../core/ui/widgets/text_label_custom.dart';
import '../../core/ui/theme/app_colors.dart';
import '../state/event_details_cubit.dart';
import '../state/event_details_state.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  late final EventModel event;
  late final UserModel user;
  late final bool createdByLoggedUser;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventDetailsCubit(Get.arguments),
        child: BlocListener<EventDetailsCubit, EventDetailsState>(
          listener: (context, state) {
            if (state is EventDetailsSuccess) {
              context
                  .read<EventDetailsCubit>()
                  .showSuccessDialog(state.message);
            } else if (state is EventDetailsError) {
              context
                  .read<EventDetailsCubit>()
                  .showErrorDialog(state.message);
            }
          },
          child: BlocBuilder<EventDetailsCubit, EventDetailsState>(
            builder: (context, state) {
              if (state is EventDetailsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is EventDetailsLoaded) {
                return _buildEventDetails(context, state);
              } else {
                return Center(child: Text(StringConstants.noData));
              }
            },
          ),
        ));
  }

  Widget _buildEventDetails(BuildContext context, EventDetailsLoaded state) {
    event = state.event;
    user = state.user;
    createdByLoggedUser = state.createdByLoggedUser;
    titleController.text = event.title;
    descriptionController.text = event.description;
    if (createdByLoggedUser) {
      return _buildCreatorView(context);
    } else {
      return _buildParticipantView(context);
    }
  }

  Widget _buildCreatorView(BuildContext context) {
    return BlocListener<EventDetailsCubit, EventDetailsState>(
      listener: (context, state) {
        if (state is EventDetailsSuccess) {
          context.read<EventDetailsCubit>().showSuccessDialog(state.message);
        } else if (state is EventDetailsError) {
          context.read<EventDetailsCubit>().showErrorDialog(state.message);
        }
      },
      child: BaseWidget(
        navBarTitle: StringConstants.eventDetailsTitle,
        withOutNavigationBar: false,
        isBackGestureEnabled: true,
        body: SingleChildScrollView(
          child: _buildEventDetailsCreatorWidget(context),
        ),
      ),
    );
  }

  Widget _buildParticipantView(BuildContext context) {
    return BaseWidget(
      navBarTitle: StringConstants.eventDetailsTitle,
      withOutNavigationBar: false,
      isBackGestureEnabled: true,
      body: SingleChildScrollView(
          child: _buildEventDetailsParticipantWidget(context)),
    );
  }

  Widget _buildEventDetailsCreatorWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEventDetailsContent(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        CustomButton(
          onPressed: () {
            context.read<EventDetailsCubit>().deleteEvent(event.uuid);
          },
          text: StringConstants.deleteEvent,
          fillColor: AppColors.secondaryColor,
        ),
      ],
    ).paddingAll(16.0);
  }

  Widget _buildEventDetailsParticipantWidget(BuildContext context) {
    final cubit = context.read<EventDetailsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEventDetailsContent(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        event.safeParticipantsEmails!.contains(user.email)
            ? CustomButton(
                text: StringConstants.unregisterFromEvent,
                onPressed: () {
                  cubit.unregisterFromEvent(event.uuid);
                },
                fillColor: AppColors.mainColor,
              )
            : CustomButton(
                text: StringConstants.registerToEvent,
                onPressed: () {
                  cubit.registerToEvent(event.uuid);
                },
              ),
      ],
    ).paddingAll(16.0);
  }

  Widget buildEventDetailsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabelCustom(StringConstants.eventTitle,
            styleEnum: TextStyleCustomEnum.bold),
        TextLabelCustom(event.title, styleEnum: TextStyleCustomEnum.normal),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        TextLabelCustom(StringConstants.eventDescription,
            styleEnum: TextStyleCustomEnum.bold),
        TextLabelCustom(event.description,
            styleEnum: TextStyleCustomEnum.italicNormal),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        TextLabelCustom(StringConstants.startDate,
            styleEnum: TextStyleCustomEnum.bold),
        TextLabelCustom(formatDateWithOrdinal(event.startDate),
            styleEnum: TextStyleCustomEnum.italicNormal),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        TextLabelCustom(StringConstants.endDate,
            styleEnum: TextStyleCustomEnum.bold),
        TextLabelCustom(formatDateWithOrdinal(event.endDate),
            styleEnum: TextStyleCustomEnum.italicNormal),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        TextLabelCustom(StringConstants.participants,
            styleEnum: TextStyleCustomEnum.bold),
        event.safeParticipantsEmails.isEmpty
            ? TextLabelCustom(StringConstants.emptyParticipants)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...event.safeParticipantsEmails
                      .map((email) => TextLabelCustom(email))
                ],
              ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        TextLabelCustom(StringConstants.notes,
            styleEnum: TextStyleCustomEnum.bold),
        event.safeNotes.isEmpty
            ? TextLabelCustom(StringConstants.emptyNotes)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...event.safeNotes.map((note) => TextLabelCustom(note))
                ],
              ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        CustomButton(
          onPressed: () {
            //TODO add note
          },
          text: StringConstants.addNote,
          fillColor: AppColors.secondaryColor,
        ),
      ],
    );
  }

  String formatDateWithOrdinal(DateTime date) {
    int day = date.day;
    String suffix = (day == 1 || day == 21 || day == 31)
        ? 'st'
        : (day == 2 || day == 22)
            ? 'nd'
            : (day == 3 || day == 23)
                ? 'rd'
                : 'th';

    return '$day$suffix ${DateFormat('MMMM yyyy').format(date)}';
  }
}
