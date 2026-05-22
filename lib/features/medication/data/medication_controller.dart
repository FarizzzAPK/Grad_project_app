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

  /// Add a new medication
  Future<bool> addMedication({
    required String name,
    required String dosage,
    required String frequency,
    required String startDate,
    required String endDate,
    List<String>? reminderTimes,
    List<String>? daysOfWeek,
    String? notes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = {
        "name": name,
        "dosage": dosage,
        "frequency": frequency,
        "startDate": startDate,
        "endDate": endDate,
        "reminderTimes": reminderTimes,
        "daysOfWeek": daysOfWeek ?? [],
        "notes": notes ?? "",
      };

      final response = await ApiService.instance.post(
        ApiConstants.patientMedications,
        body: body,
        requireAuth: true,
      );

      if (response['success'] == true) {
        // Optionally fetch the list again to update the UI
        await fetchMedications();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      print('Error adding medication: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  /// Edit a medication (only works if added by patient "self")
  Future<bool> editMedication({
    required int id,
    required String name,
    required String dosage,
    required String frequency,
    required String startDate,
    required String endDate,
    List<String>? reminderTimes,
    List<String>? daysOfWeek,
    String? notes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = {
        "name": name,
        "dosage": dosage,
        "frequency": frequency,
        "startDate": startDate,
        "endDate": endDate,
        "reminderTimes": reminderTimes,
        "daysOfWeek": daysOfWeek ?? [],
        "notes": notes ?? "",
      };

      await ApiService.instance.put(
        '${ApiConstants.patientMedications}/$id',
        body: body,
        requireAuth: true,
      );

      // Successfully edited, we can fetch the list again
      await fetchMedications();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      print('Error editing medication: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a medication (only works if added by patient "self")
  Future<bool> deleteMedication(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiService.instance.delete(
        '${ApiConstants.patientMedications}/$id',
        requireAuth: true,
      );

      // Successfully deleted, we can fetch the list again
      await fetchMedications();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      print('Error deleting medication: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
