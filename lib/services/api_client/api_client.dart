import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../flavors.dart';
import 'base_api_client.dart';
import 'interceptors/error_interceptor.dart';

class ApiClient implements BaseApiClient {
  static BaseOptions opts = BaseOptions(
    baseUrl: appFlavor.baseUrl,
    connectTimeout: appFlavor.connectTimeout,
    receiveTimeout: 20000,
  );

  final Dio _dio = createDio(opts);

  @override
  Dio get dio => _dio;

  static Dio createDio(BaseOptions opts) {
    final dio = Dio(opts);
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true),
      );
    }

    dio.interceptors.add(ErrorInterceptor());
    return dio;
  }

  @override
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, bool noCache = false}) {
    final noCacheHeader = Options(headers: {'Cache-Control': 'no-cache'});
    return _dio.get<T>(path, queryParameters: queryParameters, options: noCache ? noCacheHeader : null);
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return _dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  @override
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.delete(path, queryParameters: queryParameters);
  }
}
