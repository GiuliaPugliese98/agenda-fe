import 'package:get/get.dart';
import '../../core/data/models/user_model/user_model.dart';

class UserController extends GetxController {
  var user = Rx<UserModel?>(null);

  Future<void> setUser(UserModel newUser) async {
    user.value = newUser;
  }
}
