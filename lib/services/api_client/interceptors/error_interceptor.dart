import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../models/app/dio_error_message.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isResponseWithError(response)) {
      final dioError = DioError(
        requestOptions: response.requestOptions,
        response: response,
        type: DioErrorType.response,
        error: _getErrorMessage(response),
      );
      handler.reject(dioError, true);
    }

    super.onResponse(response, handler);
  }

  bool _isResponseWithError(Response response) {
    return response.data != null &&
        response.data is Map &&
        response.data['header'] != null &&
        response.data['header']['status'] != null &&
        response.data['header']['status'] is String &&
        'Success'.toLowerCase() != response.data['header']['status'].toString().toLowerCase();
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.cancel:
        err.error = DioErrorMessage(message: 'Request to API server was cancelled');
        break;
      case DioErrorType.connectTimeout:
        err.error = DioErrorMessage(message: 'Connection to API server timed out');
        break;
      case DioErrorType.other:
        err.error = DioErrorMessage(message: 'Connection to API server failed due to internet connection');
        break;
      case DioErrorType.receiveTimeout:
        err.error = DioErrorMessage(message: 'Receive timeout in connection with API server');
        break;
      case DioErrorType.sendTimeout:
        err.error = DioErrorMessage(message: 'Send timeout in connection with API server');
        break;
      case DioErrorType.response:
        final response = err.response;
        if (response == null) {
          err.error = DioErrorMessage(message: 'Invalid response');
          break;
        }

        if (response.statusCode == HttpStatus.unauthorized) {
          err.error = DioErrorMessage(message: 'Unauthorized');
        } else if (response.statusCode == HttpStatus.forbidden) {
          err.error = DioErrorMessage(message: 'Forbidden');
        } else if (response.statusCode == HttpStatus.notFound) {
          err.error = DioErrorMessage(message: '${response.statusCode} Page not found.');
        } else if (response.statusCode == HttpStatus.internalServerError) {
          err.error = DioErrorMessage(message: '${response.statusCode} Internal server error.');
        } else if (response.data is String) {
          err.error = DioErrorMessage(message: '${response.statusCode}: ${response.data}');
        } else if (_isResponseWithError(response) || response.data?['message'] is String) {
          err.error = _getErrorMessage(response);
        } else {
          err.error = DioErrorMessage(message: 'Received invalid status code: ${response.statusCode}');
        }

        break;
    }

    log(
      'Dio Error: ${err.error} Message: ${err.message} Response: ${jsonEncode(err.response?.data)}',
      stackTrace: err.stackTrace,
    );

    super.onError(err, handler);
  }

  DioErrorMessage? _getErrorMessage(Response response) {
    if (response.data == null || response.data['header'] == null) {
      return DioErrorMessage(message: null);
    } else if (response.data['header']['displayMessage'] != null) {
      return DioErrorMessage(showMessage: true, message: response.data['header']['displayMessage']);
    } else if (response.data['header']['message'] != null) {
      return DioErrorMessage(message: response.data['header']['message']);
    } else if (response.data['message'] != null) {
      return DioErrorMessage(message: response.data['message']);
    }
    return null;
  }
}
