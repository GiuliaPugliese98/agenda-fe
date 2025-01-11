import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/costants/string_constants.dart';
import '../../core/data/models/user_model/user_model.dart';

class UserController extends GetxController {
  var user = Rx<UserModel?>(null);

  Future<void> setUser(UserModel newUser) async {
    user.value = newUser;
  }
}
