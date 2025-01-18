import 'package:agenda/core/data/models/event_model/event_model.dart';
import 'package:agenda/core/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import '../../core/bloc/base_cubit.dart';
import 'package:get/get.dart';
import '../../core/costants/string_constants.dart';
import '../../core/data/repository/event_repository.dart';
import '../../core/network/api_client.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';
import 'event_details_state.dart';

class EventDetailsCubit extends BaseCubit<EventDetailsState> {
  final EventRepository eventRepository = Get.find<EventRepository>();
  final UserRepository userRepository = Get.find<UserRepository>();

  EventDetailsCubit(String uuid) : super(EventDetailsInit()) {
    loadEventDetails(uuid);
  }

  void loadEventDetails(String eventUuid) async {
    emit(EventDetailsLoading());
    try {
      final user = await userRepository.getUser();
      EventModel event = await eventRepository.getEventByUuid(eventUuid);
      bool createdByLoggedUser = event.createdByLoggedUser;
      emit(EventDetailsLoaded(
          event: event, user: user, createdByLoggedUser: createdByLoggedUser));
    } catch (e) {
      emit(EventDetailsError(message: e.toString()));
    }
  }

  void deleteEvent(String eventUuid) async {
    emit(EventDetailsLoading());
    try {
      await eventRepository.deleteEvent(eventUuid);
      emit(EventDeleteSuccess(message: StringConstants.eventDeleted));
    } on InternalServerErrorException {
      emit(EventDetailsError(message: StringConstants.eventDeletedNotFound));
    } on NotFoundException {
      emit(EventDetailsError(message: StringConstants.eventDeletedNotFound));
    } catch (e) {
      emit(EventDetailsError(message: e.toString()));
    }
  }

  void registerToEvent(String eventUuid) async {
    emit(EventDetailsLoading());
    try {
      await eventRepository.registerToEvent(eventUuid);
      emit(EventDetailsSuccess(
          message: StringConstants.eventRegistrationSuccessful));
    } catch (e) {
      emit(EventDetailsError(message: e.toString()));
    }
  }

  void unregisterFromEvent(String eventUuid) async {
    emit(EventDetailsLoading());
    try {
      await eventRepository.unregisterFromEvent(eventUuid);
      emit(EventDetailsSuccess(
          message: StringConstants.eventUnregistrationSuccessful));
    } catch (e) {
      emit(EventDetailsError(message: e.toString()));
    }
  }

  Future<void> showErrorDialog(
      BuildContext context, String message, String uuid) async {
    showAlertError(context, message, callbackConfirmButton: (){
      AppRoutes.pushNamed(
        Routes.eventDetail,
        pathParameters: {'uuid': uuid},
      );
    });
  }

  Future<void> showSuccessDialog(
      BuildContext context, String message, String uuid) async {
    showAlertSuccess(context, callbackConfirmButton: () {
      AppRoutes.pushNamed(
        Routes.eventDetail,
        pathParameters: {'uuid': uuid},
      );
    }, StringConstants.success_title, message, StringConstants.ok);
  }

  Future<void> showDeleteSuccessDialog(
      BuildContext context, String message) async {
    showAlertSuccess(context, callbackConfirmButton: () {
      DateTime currentDate = DateTime.now();
      String month = currentDate.month.toString();
      String year = currentDate.year.toString();
      AppRoutes.pushNamed(
        Routes.calendar,
        pathParameters: {'month': month, 'year': year},
      );
    }, StringConstants.success_title, message, StringConstants.ok);
  }

  void addNoteToEvent(
      BuildContext context, String eventUuid, String note) async {
    emit(EventDetailsLoading());
    try {
      await eventRepository.addNoteToEvent(eventUuid, note);
      emit(
          EventDetailsSuccess(message: StringConstants.eventAddNoteSuccessful));
    } catch (e) {
      emit(EventDetailsError(message: "Failed to add note: ${e.toString()}"));
    }
  }
}
