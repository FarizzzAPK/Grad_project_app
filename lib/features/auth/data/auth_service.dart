import 'dart:convert';
import 'dart:developer';
import 'package:clincal/core/api/api_service.dart';
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

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  /// Returns true if the current access token is expired
  Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) return true;
    return JwtDecoder.isExpired(token);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      if (JwtDecoder.isExpired(token)) return null;

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      print("===== JWT DECODED: $decodedToken =====");

      return {
        'userId':
            decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
            decodedToken['nameid'] ??
            '',
        'name':
            decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
            decodedToken['unique_name'] ??
            decodedToken['name'] ??
            decodedToken['Name'] ??
            decodedToken['USERNAME'] ??
            decodedToken['Username'] ??
            '',
        'email':
            decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
            decodedToken['email'] ??
            decodedToken['Email'] ??
            '',
        'role':
            decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
            decodedToken['role'] ??
            decodedToken['Role'] ??
            '',
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

  /// Attempts to refresh the access token using the refresh token endpoint.
  /// Returns the new access token on success, or null on failure.
  Future<String?> refreshAccessToken() async {
    try {
      final currentToken = await getToken();
      if (currentToken == null) return null;

      final urlString = '${ApiConstants.baseUrl}${ApiConstants.refreshToken}'
          .replaceAll('//api', '/api');
      final url = Uri.parse(urlString);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'accessToken': currentToken}),
      );

      final data = _handleResponse(response);

      if (data['accessToken'] != null) {
        await saveToken(
          data['accessToken'],
          refreshToken: data['refreshToken'],
        );
        print('===== Token refreshed successfully =====');
        return data['accessToken'];
      }

      return null;
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
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

      if (professionalPracticeLicense != null &&
          professionalPracticeLicense.isNotEmpty) {
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
        body: jsonEncode({'usernameOrEmail': email, 'password': password}),
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
      log("$e");
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Deletes the user account. Requires the user's password for confirmation.
  /// Returns the API response on success, throws on failure.
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    final apiService = (await _getApiService());
    return apiService.delete(
      ApiConstants.deleteAccount,
      body: {'password': password},
      requireAuth: true,
    );
  }

  /// Updates the username. Requires the new username.
  /// Returns the API response on success, throws on failure.
  Future<Map<String, dynamic>> updateUsername(String newUserName) async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final urlString =
        '${ApiConstants.baseUrl}${ApiConstants.updateUsername}'
            .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'newUserName': newUserName}),
    );

    return _handleResponse(response);
  }

  /// Updates the email. Requires the new email address.
  /// Returns the API response on success, throws on failure.
  Future<Map<String, dynamic>> updateEmail(String newEmail) async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final urlString =
        '${ApiConstants.baseUrl}${ApiConstants.updateMail}'
            .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'newEmail': newEmail}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> forgotPassword(String emailOrPhone) async {
    final urlString = '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}'
        .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({'emailOrPhone': emailOrPhone}),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String emailOrPhone,
    required String otpCode,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final urlString = '${ApiConstants.baseUrl}${ApiConstants.resetPassword}'
        .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({
          'emailOrPhone': emailOrPhone,
          'otpCode': otpCode,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Step 1: Request a password change OTP. Requires current password + auth token.
  Future<Map<String, dynamic>> changePasswordRequest(String currentPassword) async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final urlString = '${ApiConstants.baseUrl}${ApiConstants.changePasswordRequest}'
        .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'currentPassword': currentPassword}),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Step 2: Confirm password change with OTP + new password. Requires auth token.
  Future<Map<String, dynamic>> changePasswordConfirm({
    required String otpCode,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final urlString = '${ApiConstants.baseUrl}${ApiConstants.changePasswordConfirm}'
        .replaceAll('//api', '/api');
    final url = Uri.parse(urlString);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'otpCode': otpCode,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Convenience getter for the ApiService singleton.
  Future<ApiService> _getApiService() async {
    return ApiService.instance;
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
      // Extract detailed validation errors from ASP.NET response
      final errors = responseData['errors'];
      if (errors != null && errors is Map) {
        final errorMessages = <String>[];
        errors.forEach((field, messages) {
          if (messages is List && messages.isNotEmpty) {
            errorMessages.add(messages.first.toString());
          }
        });
        if (errorMessages.isNotEmpty) {
          throw Exception(errorMessages.join('\n'));
        }
      }

      final errorMessage =
          responseData['message'] ??
          responseData['title'] ??
          'Server request failed with status: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }
}
