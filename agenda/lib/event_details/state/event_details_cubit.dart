import 'package:agenda/core/data/models/event_model/event_model.dart';
import 'package:agenda/core/data/repository/user_repository.dart';

import '../../core/bloc/base_cubit.dart';
import 'package:get/get.dart';
import '../../core/costants/string_constants.dart';
import '../../core/data/models/user_model/user_model.dart';
import '../../core/data/repository/event_repository.dart';
import '../../core/network/api_client.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';
import 'event_details_state.dart';

class EventDetailsCubit extends BaseCubit<EventDetailsState> {
  late EventModel event;
  late UserModel user;
  late bool createdByLoggedUser;
  final EventRepository eventRepository = Get.find<EventRepository>();

  EventDetailsCubit(Map<String, dynamic> arguments)
      : super(EventDetailsInit()) {
    loadEventDetails(arguments);
  }

  void loadEventDetails(Map<String, dynamic> arguments) async {
    emit(EventDetailsLoading());
    try {
      final user = await Get.find<UserRepository>().getUser();
      String eventUuid = arguments[StringConstants.eventDetailsKey];
      event = await eventRepository.getEventByUuid(eventUuid);
      createdByLoggedUser = event.createdByLoggedUser;
      emit(EventDetailsLoaded(
          event: event, user: user, createdByLoggedUser: createdByLoggedUser));
    } catch (e) {
      emit(EventDetailsError(message: e.toString()));
    }
  }

  void deleteEvent(String eventUuid) async {
    final currentState = state;
    if (currentState is EventDetailsLoaded) {
      try {
        emit(EventDetailsLoading());
        await eventRepository.deleteEvent(eventUuid);
        emit(EventDetailsSuccess(message: StringConstants.eventDeleted));
        AppRoutes.pushNamed(Routes.calendar);
      } on InternalServerErrorException {
        emit(EventDetailsError(message: StringConstants.eventDeletedNotFound));
      } on NotFoundException {
        emit(EventDetailsError(message: StringConstants.eventDeletedNotFound));
      } catch (e) {
        emit(EventDetailsError(message: e.toString()));
      }
    }
  }

  void registerToEvent(String eventId) async {
    emit(EventDetailsLoading());
    try {
      await eventRepository.registerToEvent(eventId);
      emit(EventDetailsSuccess(message: StringConstants.eventRegistrationSuccessful));
    } catch (e) {
      emit(EventDetailsError(message: e.toString()));
    }
  }

  void unregisterFromEvent(String eventId) async {
    emit(EventDetailsLoading());
    try {
      await eventRepository.unregisterFromEvent(eventId);
      emit(EventDetailsSuccess(message: StringConstants.eventUnregistrationSuccessful));
    } catch (e) {
      emit(EventDetailsError(message: e.toString()));
    }
  }

  Future<void> showErrorDialog(String message) async {
    AppRoutes.pushNamed(Routes.calendar);
    showAlertError(message);
  }

  Future<void> showSuccessDialog(String message) async {
    showAlertSuccess(
        StringConstants.success_title, message, StringConstants.ok);
  }

  void addNoteToEvent(String eventUuid, String note) async {
    emit(EventDetailsLoading());
    try {
      await eventRepository.addNoteToEvent(event.uuid, note);
      event = await eventRepository.getEventByUuid(event.uuid);
      emit(EventDetailsLoaded(event: event, user: user, createdByLoggedUser: createdByLoggedUser));
    } catch (e) {
      emit(EventDetailsError(message: "Failed to add note: ${e.toString()}"));
    }
  }

}
