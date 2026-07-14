class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? responseData;
  const ServerException(this.message, {this.statusCode, this.responseData});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  const ValidationException(this.message, {this.errors});
}
