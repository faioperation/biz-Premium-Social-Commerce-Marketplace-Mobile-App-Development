import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../error/exceptions.dart';

class NetworkService {
  final http.Client _client;
  late final String _baseUrl;

  NetworkService(this._client) {
    _baseUrl = EnvironmentConfig.baseUrl;
  }

  Future<dynamic> get(String path, {Map<String, String>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client.get(uri);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String path, {dynamic body, Map<String, String>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client.post(uri, body: body != null ? jsonEncode(body) : null);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String path, {dynamic body, Map<String, String>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client.put(uri, body: body != null ? jsonEncode(body) : null);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String path, {dynamic body, Map<String, String>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters);
      // http.delete does not officially support a body in all frameworks, but the package allows it via Request
      final request = http.Request('DELETE', uri);
      if (body != null) {
        request.body = jsonEncode(body);
      }
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    // If path is absolute URL, return it
    if (path.startsWith('http')) {
      return Uri.parse(path).replace(queryParameters: queryParameters);
    }
    
    // Merge base URL
    final uri = Uri.parse(_baseUrl + path);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: {
        ...uri.queryParameters,
        ...queryParameters,
      });
    }
    return uri;
  }

  dynamic _processResponse(http.Response response) {
    // In our architecture, the ErrorHandler will process the exceptions, 
    // but the NetworkService should throw a generic ServerException containing the response
    // if the status code is not 2xx.
    
    dynamic jsonBody;
    try {
      if (response.body.isNotEmpty) {
        jsonBody = jsonDecode(response.body);
      }
    } catch (_) {
      jsonBody = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    } else {
      throw ServerException(
        "Server Error", 
        statusCode: response.statusCode,
        responseData: jsonBody is Map<String, dynamic> ? jsonBody : null,
      );
    }
  }

  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception(error.toString());
  }
}
