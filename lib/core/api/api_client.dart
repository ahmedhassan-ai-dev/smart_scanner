import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl =
     'http://192.168.1.106:8000';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,

      connectTimeout:
          const Duration(seconds: 30),

      receiveTimeout:
          const Duration(seconds: 30),

      sendTimeout:
          const Duration(seconds: 30),
    ),
  )
    ..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
}