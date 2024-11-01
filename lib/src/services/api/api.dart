import 'dart:convert';

import 'package:emed/src/environment/environment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  static get headers async {
    final sharedPreferences = SharedPreferencesAsync();

    final token = await sharedPreferences.getString('token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<ApiResponse<ResponseBody>> post<RequestBody, ResponseBody>(
      String url, RequestBody body) async {
    final response = await http.post(
      Uri.parse('$apiUrl/$url'),
      headers: await headers,
      body: jsonEncode(body),
    );

    return ApiResponse(
        statusCode: response.statusCode, responseBody: response.body);
  }

  static Future<ApiResponse<ResponseBody>> get<ResponseBody>(String url) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$url'),
      headers: await headers,
    );

    return ApiResponse(
        statusCode: response.statusCode, responseBody: response.body);
  }
}
