import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'api_interceptor.dart';

class HttpClient {
  late final http.Client _client;

  HttpClient() {
    _client = InterceptedClient.build(
      interceptors: [
        ApiInterceptor(),
      ],
      retryPolicy: ApiRetryPolicy(),
      requestTimeout: const Duration(seconds: 15),
    );
  }

  http.Client get instance => _client;
}
