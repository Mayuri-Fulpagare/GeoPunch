import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:3000/api/v1', // 10.0.2.2 is localhost for Android Emulators
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static Dio get instance => _dio;

  // We can add Interceptors here later for attaching the JWT Token to every request
  static void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
