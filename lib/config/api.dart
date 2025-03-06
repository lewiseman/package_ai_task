import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiConfig {
  static const Duration timeoutDuration = Duration(seconds: 30);

  static String baseUrl = 'https://app.ticketmaster.com/discovery/v2';

  static String apiKey = 'msmAgH99VsgUbobINRc99qRREiCTWqdX';
  static String ddd = '7HfSa9WJDceYobrk';
}

/// Service to handle API requests
class ApiService {
  /// Builds complete URL for the endpoint
  static Uri _buildUrl(String endpoint) {
    final url = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return Uri.parse('${ApiConfig.baseUrl}/$url');
  }

  /// Creates headers with optional authentication
  static Map<String, String> _createHeaders() {
    return {'Accept': 'application/json', 'Content-Type': 'application/json'};
  }

  /// Handles HTTP response and errors
  static T _handleResponse<T>(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          if (T == String) {
            return response.body as T;
          }
          final jsondata = json.decode(response.body);
          if (T == Map<String, dynamic>) {
            return jsondata as T;
          }
          if (T == List<Map<String, dynamic>>) {
            return (jsondata as List).cast<Map<String, dynamic>>() as T;
          }
          return jsondata as T;
        } catch (e) {
          return response.body as T;
        }
      case 400:
        throw ApiException(
          'Bad request',
          statusCode: response.statusCode,
          body: response.body,
        );
      case 401:
        throw ApiException(
          'Unauthorized',
          statusCode: response.statusCode,
          body: response.body,
        );
      case 403:
        throw ApiException(
          'Forbidden',
          statusCode: response.statusCode,
          body: response.body,
        );
      case 404:
        throw ApiException(
          'Not found',
          statusCode: response.statusCode,
          body: response.body,
        );
      case 500:
      case 502:
      case 503:
        throw ApiException(
          'Server error',
          statusCode: response.statusCode,
          body: response.body,
        );
      default:
        throw ApiException(
          'Unknown error',
          statusCode: response.statusCode,
          body: response.body,
        );
    }
  }

  /// GET request
  static Future<T> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = _buildUrl(endpoint).replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _createHeaders())
          .timeout(ApiConfig.timeoutDuration);
      return _handleResponse<T>(response);
    } on SocketException {
      throw const ApiException('No internet connection');
    } on TimeoutException {
      throw const ApiException('Request timeout');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unknown error: $e');
    }
  }

  /// POST request
  static Future<T> post<T>(
    String endpoint, {
    Object? body,
    String? token,
  }) async {
    try {
      final response = await http
          .post(
            _buildUrl(endpoint),
            headers: _createHeaders(),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.timeoutDuration);
      return _handleResponse<T>(response);
    } on SocketException {
      throw const ApiException('No internet connection');
    } on TimeoutException {
      throw const ApiException('Request timeout');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unknown error: $e');
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() {
    return message;
  }
}
