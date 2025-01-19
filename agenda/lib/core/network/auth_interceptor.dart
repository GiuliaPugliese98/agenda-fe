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
    final token = await authService.getToken();
    if (token != null &&
        (!options.path.contains("auth") || options.path.contains("logout"))) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      if (err.response?.statusCode == HttpStatus.unauthorized &&
          !err.requestOptions.path.contains('login')) {
        final newToken = await authService.refreshToken();
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final opts = Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          );
          final cloneReq = await Dio().request(
            err.requestOptions.path,
            options: opts,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          handler.resolve(cloneReq);
        } else {
          AppRoutes.pushNamed(Routes.preLogin);
        }
      } else if (err.response?.statusCode == HttpStatus.forbidden) {
        AppRoutes.pushNamed(Routes.preLogin);
      } else {
        handler.next(err);
      }
    } catch (e) {
      AppRoutes.pushNamed(Routes.preLogin);
    }
  }
}
