import 'package:clincal/core/api/api_service.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/profile/patient_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileController extends ChangeNotifier {
  // Singleton so the same instance is shared across ProfileView & PersonalInfo
  ProfileController._();
  static final ProfileController instance = ProfileController._();

  /// Holds the latest patient profile data.
  final ValueNotifier<PatientDataModel?> profileData =
      ValueNotifier<PatientDataModel?>(null);

  /// Loading state exposed as a ValueNotifier.
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Fetches (or re-fetches) the patient profile from the API
  /// and updates [profileData].
  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiService.instance.get(
        '/api/Patient',
        requireAuth: true,
      );
      profileData.value = PatientDataModel.fromJson(response);
    } catch (e) {
      print("Error fetching patient profile: $e");
      profileData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Convenience: fetch and return the model (for backward compat).
  Future<PatientDataModel?> fetchPatientProfile() async {
    await loadProfile();
    return profileData.value;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final token = await AuthService.instance.getToken();
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
}
