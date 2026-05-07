import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  Future<Map<String, String>> _getHeaders({bool requireAuth = true, Map<String, String>? customHeaders}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true, Map<String, String>? headers}) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final finalHeaders = await _getHeaders(requireAuth: requireAuth, customHeaders: headers);
      final response = await http.post(
        url,
        headers: finalHeaders,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet and try again.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {bool requireAuth = true, Map<String, String>? headers}) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final finalHeaders = await _getHeaders(requireAuth: requireAuth, customHeaders: headers);
      final response = await http.get(
        url,
        headers: finalHeaders,
      ).timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet and try again.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true, Map<String, String>? headers}) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final finalHeaders = await _getHeaders(requireAuth: requireAuth, customHeaders: headers);
      final response = await http.put(
        url,
        headers: finalHeaders,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet and try again.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, {bool requireAuth = true, Map<String, String>? headers}) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final finalHeaders = await _getHeaders(requireAuth: requireAuth, customHeaders: headers);
      final response = await http.delete(
        url,
        headers: finalHeaders,
      ).timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet and try again.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> responseData;
    
    if (response.body.isNotEmpty) {
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        throw Exception('Unrecognized Server Response: Code ${response.statusCode}. Please try again later.');
      }
    } else {
      responseData = {};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseData.containsKey('success')) {
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Unable to process backend request.');
        }
      }
      return responseData;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized Access. Your session might be expired, please log back in.');
    } else {
      final errorMessage = responseData['message'] ?? responseData['title'] ?? 'Server request failed with status: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }
}
