import 'package:dio/dio.dart';

class SecretWallApi {
  SecretWallApi(String baseUrl) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _interceptors();
  }

  late Dio _dio;

  void _interceptors() {}

  Dio init() => _dio;
}
