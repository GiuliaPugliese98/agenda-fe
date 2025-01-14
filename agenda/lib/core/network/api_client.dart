import 'dart:io';

import 'package:dio/dio.dart';
import '../data/services/auth_service.dart';
import 'auth_interceptor.dart';

class ApiClient {
  final String baseUrl;
  final Dio dio;
  final AuthService authService;

  ApiClient({required this.baseUrl, required this.authService})
      : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    dio.interceptors.add(AuthInterceptor(authService: authService));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      logPrint: (log) => print(log),
    ));
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return response.data;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        throw NotFoundException('Not found');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.internalServerError) {
        throw InternalServerErrorException('Internal Server Error');
      }
      rethrow;
    }
  }

  Future<List<dynamic>> getList(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return response.data;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        throw NotFoundException('Not found');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.internalServerError) {
        throw InternalServerErrorException('Internal Server Error');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        throw NotFoundException('Not found');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.internalServerError) {
        throw InternalServerErrorException('Internal Server Error');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.unauthorized) {
        throw UnauthorizedException('Unauthorized');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.conflict) {
        throw ConflictException('Conflict');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postNote(
      String endpoint, String data) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        throw NotFoundException('Not found');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.internalServerError) {
        throw InternalServerErrorException('Internal Server Error');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.unauthorized) {
        throw UnauthorizedException('Unauthorized');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.conflict) {
        throw ConflictException('Conflict');
      }
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.delete(endpoint, data: data);
      return response.data;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        throw NotFoundException('Not found');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.internalServerError) {
        throw InternalServerErrorException('Internal Server Error');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(endpoint, data: data);
      return response.data;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        throw NotFoundException('Not found');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.internalServerError) {
        throw InternalServerErrorException('Internal Server Error');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.unauthorized) {
        throw UnauthorizedException('Unauthorized');
      } else if (e is DioError &&
          e.response?.statusCode == HttpStatus.conflict) {
        throw ConflictException('Conflict');
      }
      rethrow;
    }
  }
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class InternalServerErrorException implements Exception {
  final String message;
  InternalServerErrorException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class ConflictException implements Exception {
  final String message;
  ConflictException(this.message);
}
