import 'package:agenda/core/bloc/base_state.dart';

import '../../core/data/models/event_model/event_model.dart';
import '../../core/data/models/user_model/user_model.dart';

abstract class EventDetailsState extends BaseState{}

class EventDetailsInit extends EventDetailsState {}

class EventDetailsLoading extends EventDetailsState {}

class EventDetailsLoaded extends EventDetailsState {
  final EventModel event;
  final UserModel user;

  EventDetailsLoaded({required this.event, required this.user});
}

class EventDetailsError extends EventDetailsState {
  final String message;

  EventDetailsError({required this.message});
}

class EventDetailsSuccess extends EventDetailsState {
  final String message;

  EventDetailsSuccess({required this.message});
}