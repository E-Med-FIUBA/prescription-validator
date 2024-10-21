import 'dart:convert';

import 'package:emed/src/environment/environment.dart';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final int statusCode;
  final String responseBody;
  final T? jsonBody;

  ApiResponse(
      {required this.statusCode, required this.responseBody, this.jsonBody});

  T get body {
    if (jsonBody != null) {
      return jsonBody!;
    }

    return jsonDecode(responseBody) as T;
  }
}

class ApiService {
  static const apiUrl = Environment.apiUrl;

  static Future<ApiResponse<ResponseBody>> post<RequestBody, ResponseBody>(
      String url, RequestBody body) async {
    final response = await http.post(
      Uri.parse('$apiUrl/$url'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );

    return ApiResponse(
        statusCode: response.statusCode, responseBody: response.body);
  }
}
