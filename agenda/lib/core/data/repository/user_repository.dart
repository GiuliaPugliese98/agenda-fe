import 'package:agenda/core/costants/string_constants.dart';
import '../../manager/web_socket_manager.dart';
import '../../repository/base_repository.dart';
import '../models/user_credentials_model/user_credentials_model.dart';
import '../models/user_model/user_model.dart';
import '../services/auth_service.dart';

class UserRepository extends BaseRepository {
  final AuthService authService;
  final WebSocketManager webSocketManager = WebSocketManager();

  UserRepository(super.apiClient, this.authService);

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

      openWebSocketConnection();

      return response['accessToken'];
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> logout() async {
    webSocketManager.disconnect();
    await apiClient.delete('auth/logout', {});
    await authService.clearToken();
    await authService.clearRefreshToken();
  }

  Future<bool> isLoggedIn() async {
    var isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      openWebSocketConnection();
    }
    return isLoggedIn;
  }

  Future<String> getToken() async {
    var token = await authService.getToken();
    if (token != null) {
      return token;
    } else {
      return "";
    }
  }

  Future<UserModel> getUser() async {
    final response = await apiClient.get('users/');
    return UserModel.fromJson(response.data);
  }

  Future<void> openWebSocketConnection() async {
    var token = await getToken();
    // starts WebSocket
    webSocketManager.connect(token, StringConstants.webSocketUrl);
  }
}
