import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:clincal/main.dart';
import 'package:clincal/features/auth/views/login_view.dart';
import '../constants/api_constants.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  /// Flag to prevent multiple simultaneous refresh attempts
  bool _isRefreshing = false;

  Future<Map<String, String>> _getHeaders({
    bool requireAuth = true,
    Map<String, String>? customHeaders,
  }) async {
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

  /// Attempts to refresh the token and returns true if successful.
  Future<bool> _tryRefreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;
    try {
      final newToken = await AuthService.instance.refreshAccessToken();
      if (newToken != null) {
        return true;
      } else {
        await _handleLogout();
        return false;
      }
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleLogout() async {
    await AuthService.instance.clearAuth();
    if (navigatorKey.currentContext != null) {
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
    Map<String, String>? headers,
  }) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll(
      '//api',
      '/api',
    );
    final url = Uri.parse(urlString);

    try {
      var finalHeaders = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: headers,
      );
      var response = await http
          .post(url, headers: finalHeaders, body: body != null ? jsonEncode(body) : null)
          .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));

      // Auto-refresh on 401
      if (response.statusCode == 401 && requireAuth) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          finalHeaders = await _getHeaders(requireAuth: true, customHeaders: headers);
          response = await http
              .post(url, headers: finalHeaders, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));
        }
      }

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception(
        'Connection timed out. Please check your internet and try again.',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requireAuth = true,
    Map<String, String>? headers,
  }) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll(
      '//api',
      '/api',
    );
    final url = Uri.parse(urlString);

    try {
      var finalHeaders = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: headers,
      );
      var response = await http
          .get(url, headers: finalHeaders)
          .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));

      // Auto-refresh on 401
      if (response.statusCode == 401 && requireAuth) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          finalHeaders = await _getHeaders(requireAuth: true, customHeaders: headers);
          response = await http
              .get(url, headers: finalHeaders)
              .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));
        }
      }

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception(
        'Connection timed out. Please check your internet and try again.',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
    Map<String, String>? headers,
  }) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll(
      '//api',
      '/api',
    );
    final url = Uri.parse(urlString);

    try {
      var finalHeaders = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: headers,
      );
      var response = await http
          .put(url, headers: finalHeaders, body: body != null ? jsonEncode(body) : null)
          .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));

      // Auto-refresh on 401
      if (response.statusCode == 401 && requireAuth) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          finalHeaders = await _getHeaders(requireAuth: true, customHeaders: headers);
          response = await http
              .put(url, headers: finalHeaders, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));
        }
      }

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception(
        'Connection timed out. Please check your internet and try again.',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
    Map<String, String>? headers,
  }) async {
    final urlString = '${ApiConstants.baseUrl}$endpoint'.replaceAll(
      '//api',
      '/api',
    );
    final url = Uri.parse(urlString);

    try {
      var finalHeaders = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: headers,
      );

      Future<http.Response> sendDelete(Map<String, String> hdrs) async {
        if (body != null) {
          // Use http.Request to send a body with DELETE
          final request = http.Request('DELETE', url);
          request.headers.addAll(hdrs);
          request.body = jsonEncode(body);
          final streamed = await request.send()
              .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));
          return http.Response.fromStream(streamed);
        } else {
          return http.delete(url, headers: hdrs)
              .timeout(const Duration(milliseconds: ApiConstants.receiveTimeout));
        }
      }

      var response = await sendDelete(finalHeaders);

      // Auto-refresh on 401
      if (response.statusCode == 401 && requireAuth) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          finalHeaders = await _getHeaders(requireAuth: true, customHeaders: headers);
          response = await sendDelete(finalHeaders);
        }
      }

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception(
        'Connection timed out. Please check your internet and try again.',
      );
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
        throw Exception(
          'Unrecognized Server Response: Code ${response.statusCode}. Please try again later.',
        );
      }
    } else {
      responseData = {};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseData.containsKey('success')) {
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw Exception(
            responseData['message'] ?? 'Unable to process backend request.',
          );
        }
      }
      return responseData;
    } else if (response.statusCode == 401) {
      throw Exception(
        'Unauthorized Access. Your session might be expired, please log back in.',
      );
    } else {
      final errorMessage =
          responseData['message'] ??
          responseData['title'] ??
          'Server request failed with status: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }
}
