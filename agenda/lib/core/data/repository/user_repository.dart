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
    await apiClient.delete('auth/logout', {});
    await authService.clearToken();
    await authService.clearRefreshToken();
  }

  Future<bool> isLoggedIn() async {
    return await authService.isLoggedIn();
  }

  Future<UserModel> getUser() async {
    final response = await apiClient.get('users/');
    return UserModel.fromJson(response);
  }
}