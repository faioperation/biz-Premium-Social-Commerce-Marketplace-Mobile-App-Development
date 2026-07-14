import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ApiInterceptor implements HttpInterceptor {
  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) async {
    // TODO: Retrieve token from secure storage
    String? accessToken = 'YOUR_ACCESS_TOKEN'; // Placeholder
    
    // ignore: unnecessary_null_comparison
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
    
    request.headers['Content-Type'] = 'application/json';

    if (kDebugMode) {
      debugPrint('==> REQUEST: \${request.method} \${request.url}');
    }
    
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (kDebugMode) {
      debugPrint('<== RESPONSE [\${response.statusCode}] \${response.request?.url}');
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest({required BaseRequest request}) => true;

  @override
  FutureOr<bool> shouldInterceptResponse({required BaseResponse response}) => true;
}

class ApiRetryPolicy implements RetryPolicy {
  @override
  int get maxRetryAttempts => 3;

  @override
  FutureOr<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (response.statusCode == 401) {
      return await _refreshToken();
    }
    if (response.statusCode >= 500) {
      return true;
    }
    return false;
  }
  
  @override
  FutureOr<bool> shouldAttemptRetryOnException(Exception reason, BaseRequest request) {
    return true; 
  }

  @override
  Duration delayRetryAttemptOnException({required int retryAttempt}) => const Duration(seconds: 1);

  @override
  Duration delayRetryAttemptOnResponse({required int retryAttempt}) => const Duration(seconds: 1);

  Future<bool> _refreshToken() async {
    try {
      // TODO: Implement refresh token API call
      return true;
    } catch (e) {
      return false;
    }
  }
}
