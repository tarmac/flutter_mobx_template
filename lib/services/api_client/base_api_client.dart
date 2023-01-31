import 'package:dio/dio.dart';

abstract class BaseApiClient {
  late final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, bool noCache = false});

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters});

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters});
}
