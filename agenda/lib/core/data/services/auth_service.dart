import 'package:agenda/core/data/models/user_model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../costants/string_constants.dart';
import '../../network/api_client.dart';

class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<String?> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw UnauthorizedException('Unauthorized');
    }
    String baseUrl = Get.find<ApiClient>().baseUrl;
    final dio = Dio(BaseOptions(baseUrl: baseUrl, method: "POST"));
    try {
      final response = await dio.post(
        'auth/refreshToken',
        data: {'token': refreshToken},
      );

      if (response.data.containsKey('accessToken') &&
          response.data.containsKey('token')) {
        final newAccessToken = response.data['accessToken'];
        await saveToken(newAccessToken);

        final newRefreshToken = response.data['token'];
        await saveRefreshToken(newRefreshToken);

        return newAccessToken;
      } else {
        throw UnauthorizedException('Unauthorized');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Errore di risposta: ${e.response?.data}');
      } else {
        throw Exception('Errore di richiesta: ${e.message}');
      }
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
