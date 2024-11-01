import '../api/api.dart';

class PrescriptionService {
  static Future<Prescription> fetchPrescription(String id) async {
    try {
      final response = await ApiService.get('prescriptions/$id/verify');

      if (response.statusCode == 200) {
        return Prescription.fromApiResponse(response);
      } else {
        throw Exception('Failed to load prescription');
      }
    } catch (e) {
      throw Exception('Failed to load prescription');
    }
  }
}

class Prescription {
  final String drug;
  final String presentation;
  final String indication;
  final int quantity;
  final String doctor;

  Prescription({
    required this.drug,
    required this.presentation,
    required this.indication,
    required this.quantity,
    required this.doctor,
  });

  factory Prescription.fromApiResponse(ApiResponse<dynamic> response) {
    final data = response.body;

    return Prescription(
      drug: data['presentation']['drug']['name'],
      presentation: data['presentation']['name'],
      indication: data['indication'],
      quantity: data['quantity'],
      doctor: data['doctor']['user']['name'] +
          ' ' +
          data['doctor']['user']['lastName'],
    );
  }
}
