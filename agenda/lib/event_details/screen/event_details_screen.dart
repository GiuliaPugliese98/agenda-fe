import 'package:agenda/calendar/state/calendar_cubit.dart';
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
  final String eventUuid;
  bool isSaveNoteEnabled = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  EventDetails(this.eventUuid, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventDetailsCubit(eventUuid),
        child: BlocListener<EventDetailsCubit, EventDetailsState>(
          listener: (context, state) {
            if (state is EventDetailsSuccess) {
              context
                  .read<EventDetailsCubit>()
                  .showSuccessDialog(context, state.message, eventUuid);
            } else if (state is EventDetailsError) {
              context
                  .read<EventDetailsCubit>()
                  .showErrorDialog(context, state.message, eventUuid);
            } else if (state is EventDeleteSuccess) {
              context
                  .read<EventDetailsCubit>()
                  .showDeleteSuccessDialog(context, state.message);
            }
          },
          child: BlocBuilder<EventDetailsCubit, EventDetailsState>(
            builder: (context, state) {
              if (state is EventDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventDetailsLoaded) {
                return BaseWidget(
                    navBarTitle:
                        "${StringConstants.eventDetailsTitle} - ${state.event.title}",
                    withOutNavigationBar: false,
                    isBackGestureEnabled: true,
                    body: Scaffold(body: _buildEventDetails(context, state)));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }

  Widget _buildEventDetails(BuildContext context, EventDetailsLoaded state) {
    EventModel event = state.event;
    UserModel user = state.user;
    bool createdByLoggedUser = state.createdByLoggedUser;
    return SingleChildScrollView(
      child: createdByLoggedUser
          ? buildCreatorView(context, event, user)
          : buildParticipantView(context, event, user),
    );
  }

  Widget buildCreatorView(
      BuildContext context, EventModel event, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...buildEventDetailsContent(context, event),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        //button delete event
        Center(
          child: CustomButton(
            onPressed: () {
              context.read<EventDetailsCubit>().deleteEvent(event.uuid);
            },
            text: StringConstants.deleteEvent,
            filled: false,
            textColor: AppColors.mainColor,
          ),
        ),
      ],
    ).paddingAll(16.0);
  }

  Widget buildParticipantView(
      BuildContext context, EventModel event, UserModel user) {
    final cubit = context.read<EventDetailsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...buildEventDetailsContent(context, event),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        //button register/unregister
        Center(
          child: event.safeParticipantsEmails!.contains(user.email)
              ? CustomButton(
                  onPressed: () {
                    cubit.unregisterFromEvent(event.uuid);
                  },
                  text: StringConstants.unregisterFromEvent,
                  filled: false,
                  textColor: AppColors.mainColor,
                )
              : CustomButton(
                  onPressed: () {
                    cubit.registerToEvent(event.uuid);
                  },
                  text: StringConstants.registerToEvent,
                  filled: false,
                  textColor: AppColors.mainColor,
                ),
        ),
      ],
    ).paddingAll(16.0);
  }

  List<Widget> buildEventDetailsContent(
      BuildContext context, EventModel event) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //dates, description and notes
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //dates
              Row(
                children: [
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextLabelCustom(StringConstants.startDate,
                              styleEnum: TextStyleCustomEnum.bold),
                          TextLabelCustom(formatDateWithOrdinal(event.startDate),
                              styleEnum: TextStyleCustomEnum.italicNormal),
                        ]),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Flexible(
                    child: Column(children: [
                      TextLabelCustom(StringConstants.endDate,
                          styleEnum: TextStyleCustomEnum.bold),
                      TextLabelCustom(formatDateWithOrdinal(event.endDate),
                          styleEnum: TextStyleCustomEnum.italicNormal),
                    ]),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextLabelCustom(
                StringConstants.eventDescription,
                styleEnum: TextStyleCustomEnum.bold,
              ),
              //description
              TextLabelCustom(event.description,
                  styleEnum: TextStyleCustomEnum.italicNormal),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextLabelCustom(StringConstants.notes,
                  styleEnum: TextStyleCustomEnum.bold),
                  //notes
                  event.safeNotes.isEmpty
                      ? TextLabelCustom(StringConstants.emptyNotes)
                      : SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: event.safeNotes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextLabelCustom(
                            event.safeNotes[index],
                            align: TextAlign.start,
                            styleEnum: TextStyleCustomEnum.normal,
                          ),
                        );
                      },
                    ),
                  ),
                ]),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.20),
          //participants
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLabelCustom(
                  StringConstants.participants,
                  styleEnum: TextStyleCustomEnum.bold,
                ),
                event.safeParticipantsEmails.isEmpty
                    ? TextLabelCustom(StringConstants.emptyParticipants)
                    : SizedBox(
                  height: 150, // Altezza limitata per far scorrere i partecipanti
                  child: ListView.builder(
                    itemCount: event.safeParticipantsEmails.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0), // Spaziatura tra i riquadri
                        padding: const EdgeInsets.all(8.0), // Spaziatura interna del riquadro
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8.0), // Angoli arrotondati
                        ),
                        child: TextLabelCustom(
                          event.safeParticipantsEmails[index],
                          align: TextAlign.start,
                          styleEnum: TextStyleCustomEnum.normal,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // Sezione Attachments
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                TextLabelCustom(
                  "Attachments",
                  styleEnum: TextStyleCustomEnum.bold,
                ),
                CustomButton(
                  onPressed: () {
                    context.read<EventDetailsCubit>().uploadAttachment(event.uuid);
                  },
                  text: "Upload File",
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                if (event.safeAttachments.isNotEmpty)
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: event.safeAttachments.length,
                      itemBuilder: (context, index) {
                        final attachment = event.safeAttachments[index];
                        return ListTile(
                          title: TextLabelCustom(
                            attachment.fileName,
                            styleEnum: TextStyleCustomEnum.normal,
                            align: TextAlign.start,
                          ),
                          onTap: () {
                            context.read<EventDetailsCubit>().downloadAttachment(attachment.id, attachment.fileName);
                          },
                        );
                      },
                    ),
                  )
                else
                  TextLabelCustom(
                    "No attachments available.",
                    styleEnum: TextStyleCustomEnum.italicNormal,
                  ),
              ],
            ),
          )
        ],
      ),
      //button Add note
      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
      Center(
        child: CustomButton(
          onPressed: () {
            showAddNoteDialog(
                context, context.read<EventDetailsCubit>(), event.uuid);
          },
          text: StringConstants.addNote,
          fillColor: AppColors.secondaryColor,
        ),
      )
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

  Future showAddNoteDialog(
      BuildContext context, EventDetailsCubit cubit, String eventUuid) {
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
                              cubit.addNoteToEvent(
                                  context, eventUuid, noteController.text);
                              Navigator.of(context).pop();
                            }
                          : null,
                    ),
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
      },
    );
  }
}
