import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<List<dynamic>> getList(
    String path, {
    String? token,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: _headers(token),
    );

    final decoded = _decodeRaw(response);
    if (decoded is List) {
      return decoded;
    }
    throw const ApiException('Respuesta inesperada del servidor');
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<void> delete(
    String path, {
    String? token,
  }) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: _headers(token),
    );
    _decodeRaw(response);
  }

  Map<String, String> _headers(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = _decodeRaw(response);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw const ApiException('Respuesta inesperada del servidor');
  }

  dynamic _decodeRaw(http.Response response) {
    final dynamic data =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final message =
        data is Map<String, dynamic> && data['message'] is String
            ? data['message'] as String
            : 'Error de servidor';
    throw ApiException(message, statusCode: response.statusCode);
  }
}
