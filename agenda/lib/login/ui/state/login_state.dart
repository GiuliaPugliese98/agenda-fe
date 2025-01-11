part of 'login_cubit.dart';

class LoginState extends BaseState {}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final UserModel user;

  LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});

  @override
  List<Object> get props => [];
}

class LoginErrorUserNotAuthorized extends LoginState {
  final String error;

  LoginErrorUserNotAuthorized({required this.error});

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLockSignIn extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginUnlockSignIn extends LoginState {
  @override
  List<Object> get props => [];
}