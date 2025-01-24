import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import '../data/services/auth_service.dart';
import '../ui/app_routes/routes.dart';
import '../ui/app_routes/routes_constants.dart';

class AuthInterceptor extends Interceptor {
  final AuthService authService;

  AuthInterceptor({required this.authService});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains("auth") || options.path.contains("logout")) {
      var token = await authService.getToken();
      if (token == null || authService.tokenHasExpired(token)) {
        token = await authService.loadAccessToken;
      }
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      if (err.response?.statusCode == HttpStatus.forbidden) {
        AppRoutes.pushNamed(Routes.preLogin);
      } else {
        handler.next(err);
      }
    } catch (e) {
      AppRoutes.pushNamed(Routes.preLogin);
    }
  }
}
