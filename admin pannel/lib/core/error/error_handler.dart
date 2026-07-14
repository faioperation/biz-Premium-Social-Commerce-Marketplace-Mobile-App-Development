import 'dart:io';
import 'package:http/http.dart' as http;
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  /// Converts any Exception into a strongly typed Failure.
  static Failure handleException(dynamic exception) {
    if (exception is ServerException) {
      return _handleServerException(exception);
    } else if (exception is SocketException || exception is http.ClientException) {
      return const NetworkFailure("No Internet Connection.");
    } else if (exception is TimeoutException) {
      return const TimeoutFailure("Connection Timeout. Please try again later.");
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is UnauthorizedException) {
      return UnauthorizedFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message, errors: exception.errors);
    } else {
      return UnknownFailure("An unexpected error occurred: \${exception.toString()}");
    }
  }

  static Failure _handleServerException(ServerException exception) {
    final statusCode = exception.statusCode;
    final responseData = exception.responseData;

    String message = "Server Error";
    Map<String, dynamic>? validationErrors;

    if (responseData != null) {
      message = responseData['message'] ?? message;
      if (responseData['errors'] != null) {
        validationErrors = responseData['errors'];
      }
    }

    if (statusCode == 401 || statusCode == 403) {
      return UnauthorizedFailure(message, statusCode: statusCode);
    } else if (statusCode == 422) {
      return ValidationFailure(message, statusCode: statusCode, errors: validationErrors);
    } else if (statusCode != null && statusCode >= 500) {
      return ServerFailure(message, statusCode: statusCode);
    } else {
      return ServerFailure(message, statusCode: statusCode);
    }
  }
}
