import 'package:shared_preferences/shared_preferences.dart';
import '../../costants/string_constants.dart';
import '../../network/api_client.dart';
import '../../repository/base_repository.dart';
import '../models/user_credentials_model/user_credentials_model.dart';
import '../models/user_model/user_model.dart';
import '../services/auth_service.dart';

class UserRepository extends BaseRepository {
  final AuthService authService;

  UserRepository(ApiClient apiClient, this.authService) : super(apiClient);

  Future<UserModel> createUser(UserModel user) async {
    final response = await apiClient.post('auth/signup', user.toJson());
    return UserModel.fromJson(response);
  }

  Future<void> login(UserCredentialsModel userCredential) async {
    final response =
        await apiClient.post('auth/login', userCredential.toJson());

    if (response.containsKey('accessToken') && response.containsKey('token')) {
      await authService.saveToken(response['accessToken']);
      await authService.saveRefreshToken(response['token']);
      return response['accessToken'];
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final String uuid =
        prefs.getString(StringConstants.loggedUserUuidKey).toString();
    await apiClient.delete('auth/logout/$uuid', {});

    await authService.clearToken();
    await authService.clearRefreshToken();
    await authService.clearUserUuid();
  }

  Future<bool> isLoggedIn() async {
    return await authService.isLoggedIn();
  }

  Future<UserModel> getUser(String email) async {
    final response = await apiClient.get('users/$email');
    return UserModel.fromJson(response);
  }

  Future<UserModel> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String uuid =
        await prefs.getString(StringConstants.loggedUserUuidKey).toString();
    final response = await apiClient.get('users/uuid/$uuid');
    return UserModel.fromJson(response);
  }
}
