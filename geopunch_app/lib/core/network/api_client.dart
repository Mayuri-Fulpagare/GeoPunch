import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    // 10.245.26.96 is your computer's local Wi-Fi IP address. This works for both Emulator and Physical Phone.
    baseUrl: 'http://10.245.26.96:3000/api/v1',
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
