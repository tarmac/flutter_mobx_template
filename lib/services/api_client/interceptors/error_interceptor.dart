import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../models/app/dio_error_message.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (_isResponseWithError(response)) {
      handler.reject(
        DioException.badResponse(
          statusCode: response.statusCode ?? HttpStatus.internalServerError,
          requestOptions: response.requestOptions,
          response: response,
        ).copyWith(error: _getErrorMessage(response)),
      );
      return;
    }

    handler.next(response);
  }

  bool _isResponseWithError(Response<dynamic> response) {
    final data = response.data;
    return data != null &&
        data is Map &&
        data['header'] != null &&
        data['header']['status'] != null &&
        data['header']['status'] is String &&
        'Success'.toLowerCase() != data['header']['status'].toString().toLowerCase();
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final enrichedError = switch (err.type) {
      DioExceptionType.cancel => _withErrorMessage(
        err,
        DioErrorMessage(message: 'Request to API server was cancelled'),
      ),
      DioExceptionType.connectionTimeout => _withErrorMessage(
        err,
        DioErrorMessage(message: 'Connection to API server timed out'),
      ),
      DioExceptionType.connectionError => _withErrorMessage(
        err,
        DioErrorMessage(message: 'Connection to API server failed due to internet connection'),
      ),
      DioExceptionType.receiveTimeout => _withErrorMessage(
        err,
        DioErrorMessage(message: 'Receive timeout in connection with API server'),
      ),
      DioExceptionType.sendTimeout => _withErrorMessage(
        err,
        DioErrorMessage(message: 'Send timeout in connection with API server'),
      ),
      DioExceptionType.badResponse => _handleBadResponse(err),
      DioExceptionType.badCertificate || DioExceptionType.unknown => err,
    };

    log(
      'Dio Error: ${enrichedError.error} Message: ${enrichedError.message} Response: ${jsonEncode(enrichedError.response?.data)}',
      stackTrace: enrichedError.stackTrace,
    );

    handler.next(enrichedError);
  }

  DioException _handleBadResponse(DioException err) {
    final response = err.response;
    if (response == null) {
      return _withErrorMessage(err, DioErrorMessage(message: 'Invalid response'));
    }

    if (response.statusCode == HttpStatus.unauthorized) {
      return _withErrorMessage(err, DioErrorMessage(message: 'Unauthorized'));
    } else if (response.statusCode == HttpStatus.forbidden) {
      return _withErrorMessage(err, DioErrorMessage(message: 'Forbidden'));
    } else if (response.statusCode == HttpStatus.notFound) {
      return _withErrorMessage(err, DioErrorMessage(message: '${response.statusCode} Page not found.'));
    } else if (response.statusCode == HttpStatus.internalServerError) {
      return _withErrorMessage(err, DioErrorMessage(message: '${response.statusCode} Internal server error.'));
    } else if (response.data is String) {
      return _withErrorMessage(err, DioErrorMessage(message: '${response.statusCode}: ${response.data}'));
    } else if (_isResponseWithError(response) || response.data?['message'] is String) {
      return _withErrorMessage(err, _getErrorMessage(response));
    }

    return _withErrorMessage(err, DioErrorMessage(message: 'Received invalid status code: ${response.statusCode}'));
  }

  DioException _withErrorMessage(DioException err, DioErrorMessage? errorMessage) {
    return err.copyWith(error: errorMessage);
  }

  DioErrorMessage? _getErrorMessage(Response<dynamic> response) {
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
