import 'package:agenda/core/bloc/base_state.dart';

import '../../core/data/models/event_model/event_model.dart';
import '../../core/data/models/user_model/user_model.dart';

abstract class EventDetailsState extends BaseState{}

class EventDetailsInit extends EventDetailsState {
  @override
  List<Object?> get props => [];
}

class EventDetailsLoading extends EventDetailsState {
  @override
  List<Object?> get props => [];
}

class EventDetailsLoaded extends EventDetailsState {
  final EventModel event;
  final UserModel user;
  final bool createdByLoggedUser;

  EventDetailsLoaded({required this.event, required this.user, required this.createdByLoggedUser});
}

class EventDetailsError extends EventDetailsState {
  final String message;

  EventDetailsError({required this.message});
}

class EventDetailsSuccess extends EventDetailsState {
  final String message;
  
  EventDetailsSuccess({required this.message});
}