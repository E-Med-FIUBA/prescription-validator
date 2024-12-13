import 'dart:convert';

import 'package:emed/src/environment/environment.dart';
import 'package:emed/src/services/auth/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final int statusCode;
  final String _responseBody;

  ApiResponse({required this.statusCode, required String responseBody})
      : _responseBody = responseBody;

  T get body {
    return jsonDecode(_responseBody) as T;
  }
}

class ApiService {
  static const apiUrl = Environment.apiUrl;

  final AuthService authService;

  ApiService({required this.authService});

  get headers async {
    final token = await authService.getToken();

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  Future<ApiResponse<ResponseBody>> post<RequestBody, ResponseBody>(
      String url, RequestBody body) async {
    debugPrint('apiUrl: $apiUrl');
    final response = await http.post(
      Uri.parse('$apiUrl/$url'),
      headers: await headers,
      body: jsonEncode(body),
    );

    return _interceptResponse<ResponseBody>(response);
  }

  Future<ApiResponse<ResponseBody>> get<ResponseBody>(String url) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$url'),
      headers: await headers,
    );

    return _interceptResponse<ResponseBody>(response);
  }

  ApiResponse<ResponseBody> _interceptResponse<ResponseBody>(
      http.Response response) {
    if (response.statusCode == 401) {
      authService.logout();
    }

    return ApiResponse(
        statusCode: response.statusCode, responseBody: response.body);
  }
}
