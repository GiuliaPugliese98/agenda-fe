import 'package:agenda/registration/state/registration_state.dart';
import 'package:flutter/cupertino.dart';

import '../../core/bloc/base_cubit.dart';
import '../../core/costants/string_constants.dart';
import '../../core/data/models/user_model/user_model.dart';
import '../../core/data/repository/user_repository.dart';
import '../../core/network/api_client.dart';
import '../../core/ui/app_routes/routes.dart';
import '../../core/ui/app_routes/routes_constants.dart';

class RegistrationCubit extends BaseCubit<RegistrationState> {
  final UserRepository userRepository;
  bool disableCustomBack = false;

  RegistrationCubit(this.userRepository, arguments)
      : super(RegistrationInitial()) {
    if (arguments != null) {
      disableCustomBack = true;
      emit(RegistrationInitial());
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      emit(RegistrationLoading());
      final newUser = await userRepository.createUser(user);
      emit(RegistrationSuccess(newUser));
    } on ConflictException {
      emit(RegistrationFailure(StringConstants.registrationEmailExist));
    } on InternalServerErrorException {
      emit(RegistrationFailure(StringConstants.registrationError));
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  void lockSignUp() {
    emit(RegistrationLockSignUp());
  }

  void unlockSignUp() {
    emit(RegistrationUnlockSignUp());
  }

  void setButtonState(bool isEnabled) {
    if (isEnabled) {
      unlockSignUp();
    } else {
      lockSignUp();
    }
  }

  Future<void> showErrorDialog(BuildContext context, String message) async {
    showAlertError(context, message, callbackConfirmButton: () {
      AppRoutes.pushNamed(Routes.registration);
    });
  }
}
