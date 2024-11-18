import 'package:emed/src/services/prescription/classes/prescription.dart';
import 'package:emed/src/services/prescription/classes/prescription_metrics.dart';
import 'package:emed/src/services/prescription/classes/verified_prescription.dart';

import '../api/api.dart';

class PrescriptionService {
  PrescriptionService(this._apiService);

  final ApiService _apiService;

  Future<VerifiedPrescription> fetchPrescription(String id) async {
    try {
      final response = await _apiService.get('prescriptions/$id/verify');

      if (response.statusCode == 200) {
        return VerifiedPrescription.fromApiResponse(response);
      } else {
        throw Exception('Failed to load prescription');
      }
    } catch (e) {
      throw Exception('Failed to load prescription');
    }
  }

  Future<void> markAsUsed(String id) async {
    try {
      final response = await _apiService.post('prescriptions/$id/use', {});

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to mark prescription as used');
      }
    } catch (e) {
      throw Exception('Failed to mark prescription as used');
    }
  }

  Future<List<Prescription>> fetchPrescriptionHistory() async {
    try {
      final response = await _apiService.get('prescriptions/history');

      if (response.statusCode == 200) {
        final prescriptions = <Prescription>[];

        for (final data in response.body) {
          prescriptions.add(Prescription.fromJson(data));
        }

        return prescriptions;
      } else {
        throw Exception('Failed to load prescription history');
      }
    } catch (e) {
      throw Exception('Failed to load prescription history');
    }
  }

  Future<PrescriptionMetricsData> fetchPrescriptionMetrics() async {
    try {
      final response = await _apiService.get('prescriptions/metrics');

      if (response.statusCode == 200) {
        return PrescriptionMetricsData.fromApiResponse(response);
      } else {
        throw Exception('Failed to load prescription metrics');
      }
    } catch (e) {
      throw Exception('Failed to load prescription metrics');
    }
  }
}
