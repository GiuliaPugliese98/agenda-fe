import 'package:agenda/core/costants/string_constants.dart';
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
      endDate: endDate
    );
    emit(AddEventLoading());
    try {
      await eventRepository.createEvent(newEvent);
      emit(AddEventSuccess(StringConstants.addEventSuccess));
      AppRoutes.pushNamed(Routes.calendar);
    } on InternalServerErrorException {
      emit(AddEventError(StringConstants.addEventError));
    } catch (e) {
      emit(AddEventError(e.toString()));
    }
  }

  Future<void> showErrorDialog(String message) async {
    showAlertError(message);
  }

  Future<void> showSuccessDialog(String message) async {
    AppRoutes.pushNamed(Routes.calendar);
    showAlertSuccess(
        StringConstants.success, message, StringConstants.ok);
  }
}