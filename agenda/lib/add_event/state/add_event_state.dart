import '../../core/bloc/base_state.dart';

class AddEventState extends BaseState {}

class AddEventInit extends AddEventState {
  @override
  List<Object?> get props => [];
}

class AddEventLoading extends AddEventState {
  @override
  List<Object?> get props => [];
}

class AddEventLoaded extends AddEventState {
  @override
  List<Object?> get props => [];
}

class AddEventSuccess extends AddEventState {
  final String message;
  AddEventSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddEventError extends AddEventState {
  final String message;
  AddEventError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddEventLockAdd extends AddEventState {
  @override
  List<Object> get props => [];
}

class AddEventUnlockAdd extends AddEventState {
  @override
  List<Object> get props => [];
}
class EndDateLock extends AddEventState {
  @override
  List<Object> get props => [];
}

class EndDateUnlock extends AddEventState {
  @override
  List<Object> get props => [];
}