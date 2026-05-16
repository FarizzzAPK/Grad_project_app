import 'package:flutter/foundation.dart';
import 'package:clincal/core/api/api_service.dart';
import 'package:clincal/core/constants/api_constants.dart';
import 'package:clincal/features/medication/data/medication_model.dart';

class MedicationController extends ChangeNotifier {
  List<MedicationModel> _medications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MedicationModel> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch all patient medications from the API (auth token only)
  Future<void> fetchMedications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.instance.get(
        ApiConstants.patientMedications,
        requireAuth: true,
      );

      final medicationResponse = MedicationResponse.fromJson(response);
      _medications = medicationResponse.data;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      print('Error fetching medications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get medication by ID
  MedicationModel? getMedicationById(int id) {
    try {
      return _medications.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get only doctor-prescribed medications
  List<MedicationModel> get doctorPrescribed =>
      _medications.where((m) => m.isDoctorPrescribed).toList();

  /// Get only self-added medications
  List<MedicationModel> get selfAdded =>
      _medications.where((m) => !m.isDoctorPrescribed).toList();
}
