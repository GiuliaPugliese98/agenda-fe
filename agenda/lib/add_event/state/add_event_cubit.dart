import 'package:agenda/core/costants/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/bloc/base_cubit.dart';
import '../../core/data/models/event_model_to_add/event_model_to_add.dart';
import '../../core/data/repository/event_repository.dart';
import '../../core/network/api_client.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';
import 'add_event_state.dart';

class AddEventCubit extends BaseCubit<AddEventState> {
  final EventRepository eventRepository = Get.find<EventRepository>();

  AddEventCubit() : super(AddEventInit()) {
    emit(AddEventLoaded());
  }

  void unlockAdd() {
    emit(AddEventUnlockAdd());
  }

  void lockAdd() {
    emit(AddEventLockAdd());
  }

  void unlockEndDate() {
    emit(EndDateUnlock());
  }

  void lockEndDate() {
    emit(EndDateLock());
  }

  void setButtonState(bool isEnabled) {
    if (isEnabled) {
      unlockAdd();
    } else {
      lockAdd();
    }
  }

  void addEvent({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final newEvent = EventModelToAdd(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate);
    emit(AddEventLoading());
    try {
      await eventRepository.createEvent(newEvent);
      emit(AddEventSuccess(StringConstants.addEventSuccess));
    } on InternalServerErrorException {
      emit(AddEventError(StringConstants.addEventError));
    } catch (e) {
      emit(AddEventError(e.toString()));
    }
  }

  Future<void> invalidEndDateTime(BuildContext context, String message) async {
    emit(InvalidEndDate(StringConstants.invalidEndTime));
  }

  Future<void> showErrorDialog(BuildContext context, String message) async {
    showAlertError(context, message, callbackConfirmButton: () {
      AppRoutes.pushNamed(Routes.addEvent);
    });
  }

  Future<void> showSuccessDialog(BuildContext context, String message) async {
    DateTime currentDate = DateTime.now();
    String month = currentDate.month.toString();
    String year = currentDate.year.toString();
    showAlertSuccess(
        context, StringConstants.success, message, StringConstants.ok,
        callbackConfirmButton: () {
      AppRoutes.pushNamed(
        Routes.calendar,
        pathParameters: {'month': month, 'year': year},
      );
    });
  }
}
