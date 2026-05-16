import 'package:clincal/core/api/api_service.dart';
import 'package:clincal/core/constants/api_constants.dart';
import 'package:clincal/features/requests/models/patient_request_model.dart';
import 'package:flutter/foundation.dart';

class RequestsController extends ChangeNotifier {

  Future<List<PatientRequest>> fetchPatientRequests() async {
    try {
      final response = await ApiService.instance.get(
        ApiConstants.getPatientRequests,
        requireAuth: true,
      );
      final parsed = PatientRequestResponse.fromJson(response);
      return parsed.data;
    } catch (e) {
      print("Error fetching patient requests: $e");
      return [];
    }
  }
}
