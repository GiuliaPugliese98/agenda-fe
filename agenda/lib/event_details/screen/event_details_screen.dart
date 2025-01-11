import 'package:agenda/core/data/models/user_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/data/models/event_model/event_model.dart';
import '../../core/enums/text_style_custom_enum.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../../core/ui/widgets/text_label_custom.dart';
import '../../core/ui/theme/app_colors.dart';
import '../state/event_details_cubit.dart';
import '../state/event_details_state.dart';

class EventDetails extends StatelessWidget {
  late final EventModel event;
  late final UserModel user;
  final bool isCreator;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  EventDetails({required this.isCreator, required this.event});

  @override
  Widget build(BuildContext context) {
    if (isCreator) {
      return _buildCreatorView(context);
    } else {
      return _buildParticipantView(context);
    }
  }

  Widget _buildCreatorView(BuildContext context) {
    return BlocProvider(
      create: (context) => EventDetailsCubit(Get.arguments),
      child: BlocListener<EventDetailsCubit, EventDetailsState>(
        listener: (context, state) {
          if (state is EventDetailsSuccess) {
            context.read<EventDetailsCubit>().showSuccessDialog(state.message);
          } else if (state is EventDetailsError) {
            context.read<EventDetailsCubit>().showErrorDialog(state.message);
          }
        },
        child: BlocBuilder<EventDetailsCubit, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoaded) {
              event = state.event;
              user = state.user;
              titleController.text = event.title;
              descriptionController.text = event.description;
            }
            return BaseWidget(
              navBarTitle: StringConstants.eventDetailsTitle,
              withOutNavigationBar: false,
              isBackGestureEnabled: true,
              body: Scaffold(
                  body: _buildEventDetailsCreatorWidget(context, event)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildParticipantView(BuildContext context) {
    return BaseWidget(
      navBarTitle: StringConstants.eventDetailsTitle,
      withOutNavigationBar: false,
      isBackGestureEnabled: true,
      body: Scaffold(body: _buildEventDetailsParticipantWidget(context)),
    );
  }

  Widget _buildEventDetailsCreatorWidget(
      BuildContext context, EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabelCustom(event.title, styleEnum: TextStyleCustomEnum.bold),
        TextLabelCustom(event.description,
            styleEnum: TextStyleCustomEnum.italicNormal),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () {
            AppRoutes.pushNamed(Routes.eventDetail, arguments: event);
          },
          text: StringConstants.editEvent,
        ),
        const SizedBox(height: 10),
        CustomButton(
          onPressed: () {
            context.read<EventDetailsCubit>().deleteEvent(event.uuid);
          },
          text: StringConstants.deleteEvent,
          fillColor: AppColors.mainColor,
        ),
      ],
    ).paddingAll(16.0);
  }

  Widget _buildEventDetailsParticipantWidget(BuildContext context) {
    final cubit = context.read<EventDetailsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabelCustom(event.title, styleEnum: TextStyleCustomEnum.bold),
        TextLabelCustom(event.description,
            styleEnum: TextStyleCustomEnum.italicNormal),
        const SizedBox(height: 20),
        event.participantsEmails!.contains(user)
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
}