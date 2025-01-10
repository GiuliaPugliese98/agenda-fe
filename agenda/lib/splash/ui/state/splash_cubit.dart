import 'package:get/get.dart';
import '../../../core/bloc/base_cubit.dart';
import '../../../core/bloc/base_state.dart';
import '../../../core/data/models/user_model/user_model.dart';
import '../../../core/data/repository/user_repository.dart';
import '../../../core/ui/app_routes/routes.dart';
import '../../../core/ui/app_routes/routes_constants.dart';
import '../../../login/ui/user_controller.dart';

part 'splash_state.dart';

class SplashCubit extends BaseCubit<SplashState> {
  final UserRepository userRepository = Get.find<UserRepository>();

  SplashCubit() : super(SplashState());

  Future<void> onInit() async {
    try {
      bool isLoggedIn = await userRepository.isLoggedIn();
      if (isLoggedIn) {
        final userController = Get.find<UserController>();
        UserModel user = await userRepository.getLoggedUser();
        userController.setUser(user);

        if (Get.currentRoute == Routes.login || Get.currentRoute == Routes.splash ) {
          //TODO
        }
      } else {
        AppRoutes.pushNamed(Routes.preLogin);
      }
    } catch (e) {
      AppRoutes.pushNamed(Routes.preLogin);
    }
  }

}