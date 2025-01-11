import 'package:get/get.dart';
import '../../../core/bloc/base_cubit.dart';
import '../../../core/bloc/base_state.dart';
import '../../../core/costants/string_constants.dart';
import '../../../core/data/models/user_credentials_model/user_credentials_model.dart';
import '../../../core/data/models/user_model/user_model.dart';
import '../../../core/data/repository/user_repository.dart';
import '../../../core/network/api_client.dart';

part 'login_state.dart';

class LoginCubit extends BaseCubit<LoginState> {
  final UserRepository userRepository = Get.find<UserRepository>();

  LoginCubit() : super(LoginState());

  void unlockSignIn() async {
    emit(LoginUnlockSignIn());
  }

  void lockSignIn() {
    emit(LoginLockSignIn());
  }

  void setButtonState(bool isEnabled) {
    if (isEnabled) {
      unlockSignIn();
    } else {
      lockSignIn();
    }
  }

  Future<void> login(UserCredentialsModel userCredentials) async {
    emit(LoginLoading());
    try {
      await userRepository.login(userCredentials);
      UserModel user = await userRepository.getUser();
      emit(LoginSuccess(user: user));
    } on UnauthorizedException {
      emit(LoginErrorUserNotAuthorized(error: StringConstants.loginUnauthorized));
    } catch (e) {
      emit(LoginError(error: e.toString()));
    }
  }

  Future<void> showErrorDialog(String message) async {
    showAlertError(message);
  }
}
