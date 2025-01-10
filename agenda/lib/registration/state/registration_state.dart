import '../../core/bloc/base_state.dart';
import '../../core/data/models/user_model/user_model.dart';

class RegistrationState extends BaseState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLockSignUp extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RegistrationUnlockSignUp extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RegistrationSuccess extends RegistrationState {
  final UserModel user;
  RegistrationSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class RegistrationFailure extends RegistrationState {
  final String error;
  RegistrationFailure(this.error);

  @override
  List<Object> get props => [error];
}
