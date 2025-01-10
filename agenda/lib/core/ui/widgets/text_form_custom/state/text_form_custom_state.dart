import '../../../../bloc/base_state.dart';

abstract class TextFormFieldCustomState extends BaseState {
  final bool passwordVisibility;

  TextFormFieldCustomState(this.passwordVisibility);

  @override
  List<Object> get props => [passwordVisibility];
}

class PasswordVisibilityInitial extends TextFormFieldCustomState {
  PasswordVisibilityInitial() : super(false);
}

class ChangePasswordVisibility extends TextFormFieldCustomState {
  final bool visible;

  ChangePasswordVisibility(this.visible) : super(visible);
}
