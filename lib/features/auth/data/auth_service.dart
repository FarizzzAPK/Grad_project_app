import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../core/constants/api_constants.dart';

class AuthService {
  // Make a private constructor
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      if (JwtDecoder.isExpired(token)) return null;

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      
      print("===== JWT DECODED: $decodedToken =====");

      return {
        'userId': decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ?? decodedToken['nameid'] ?? '',
        'name': decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ?? decodedToken['unique_name'] ?? decodedToken['name'] ?? decodedToken['Name'] ?? decodedToken['USERNAME'] ?? decodedToken['Username'] ?? '',
        'email': decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ?? decodedToken['email'] ?? decodedToken['Email'] ?? '',
        'role': decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ?? decodedToken['role'] ?? decodedToken['Role'] ?? '',
      };
    } catch (e) {
      print("JWT Parse Error: $e");
      return null;
    }
  }

  Future<void> saveToken(String token, {String? refreshToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    if (refreshToken != null) {
      await prefs.setString('refresh_token', refreshToken);
    }
  }

  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
  }

  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<Map<String, dynamic>> loginWithGoogle(
      String idToken, {
      bool isDoctor = false,
      String? professionalPracticeLicense,
      String? issuingAuthority,
  }) async {
    final urlString = '${ApiConstants.baseUrl}${ApiConstants.loginWithGoogle}'
        .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final headers = await _getHeaders();
      headers['X-Client-Type'] = 'server';
      final Map<String, dynamic> body = {
        'idToken': idToken,
        'isDoctor': isDoctor,
      };

      if (professionalPracticeLicense != null && professionalPracticeLicense.isNotEmpty) {
        body['professionalPracticeLicense'] = professionalPracticeLicense;
      }
      if (issuingAuthority != null && issuingAuthority.isNotEmpty) {
        body['issuingAuthority'] = issuingAuthority;
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      final data = _handleResponse(response);

      if (data['accessToken'] != null) {
        await saveToken(
          data['accessToken'],
          refreshToken: data['refreshToken'],
        );
      }

      return data;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final urlString = '${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'
        .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final headers = await _getHeaders();
      headers['X-Client-Type'] = 'server';
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'usernameOrEmail':
              email,
          'password': password,
        }),
      );

      final data = _handleResponse(response);

      if (data['accessToken'] != null) {
        await saveToken(
          data['accessToken'],
          refreshToken: data['refreshToken'],
        );
      }

      return data;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final urlString = '${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}'
        .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(userData),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> responseData;
    try {
      responseData = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Unrecognized Server Response: ${response.statusCode}.');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseData['success'] == true) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Unable to process request.',
        );
      }
    } else {
      final errorMessage =
          responseData['message'] ??
          responseData['title'] ??
          'Server request failed with status: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }
}
