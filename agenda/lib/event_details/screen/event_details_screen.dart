import 'package:agenda/core/data/models/user_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/data/models/event_model/event_model.dart';
import '../../core/enums/form_field_custom_type_enum.dart';
import '../../core/enums/text_style_custom_enum.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../../core/ui/widgets/text_form_custom/screen/text_form_custom_screen.dart';
import '../../core/ui/widgets/text_label_custom.dart';
import '../../core/ui/theme/app_colors.dart';
import '../state/event_details_cubit.dart';
import '../state/event_details_state.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  late final EventModel event;
  late final UserModel user;
  late final bool createdByLoggedUser;
  bool isSaveNoteEnabled = false;
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
              context.read<EventDetailsCubit>().showErrorDialog(state.message);
            }
          },
          child: BlocBuilder<EventDetailsCubit, EventDetailsState>(
            builder: (context, state) {
              if (state is EventDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventDetailsLoaded) {
                return BaseWidget(
                    navBarTitle: StringConstants.eventDetailsTitle,
                    withOutNavigationBar: false,
                    isBackGestureEnabled: true,
                    body: Scaffold(body: _buildEventDetails(context, state)));
              } else {
                return const Center(child: Text(StringConstants.noData));
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
    return SingleChildScrollView(
      child: createdByLoggedUser
          ? buildCreatorView(context)
          : buildParticipantView(context),
    );
  }

  Widget buildCreatorView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...buildEventDetailsContent(context),
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

  Widget buildParticipantView(BuildContext context) {
    final cubit = context.read<EventDetailsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...buildEventDetailsContent(context),
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

  List<Widget> buildEventDetailsContent(BuildContext context) {
    return [
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
          showAddNoteDialog(context, context.read<EventDetailsCubit>());
        },
        text: StringConstants.addNote,
        fillColor: AppColors.secondaryColor,
      ),
    ];
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

    return '$day$suffix ${DateFormat('MMMM yyyy HH:mm').format(date)}';
  }

  Future showAddNoteDialog(BuildContext context, EventDetailsCubit cubit) {
    final TextEditingController noteController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false, // Deve usare i bottoni per chiudere
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void checkSaveNoteButton() {
              setState(() {
                isSaveNoteEnabled = noteController.text.isNotEmpty;
              });
            }
            return AlertDialog(
              title: const Text(StringConstants.addNote),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormFieldCustom(
                      labelText: StringConstants.note,
                      formFieldType: FormFieldCustomTypeEnum.text,
                      hintText: StringConstants.noteHintText,
                      textEditingController: noteController,
                      onChanged: (_) => checkSaveNoteButton(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    CustomButton(
                      filled: isSaveNoteEnabled,
                      text: StringConstants.save,
                      onPressed: isSaveNoteEnabled
                          ? () {
                        cubit.addNoteToEvent(event.uuid, noteController.text);
                        Navigator.of(context).pop();
                      }
                          : null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    CustomButton(
                      text: StringConstants.cancel,
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
      },
    );
  }
}
