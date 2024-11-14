import '../api/api.dart';

class PrescriptionService {
  PrescriptionService(this._apiService);

  final ApiService _apiService;

  Future<Prescription> fetchPrescription(String id) async {
    try {
      final response = await _apiService.get('prescriptions/$id/verify');

      if (response.statusCode == 200) {
        return Prescription.fromApiResponse(response);
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
}

class Prescription {
  final String drug;
  final String presentation;
  final int quantity;
  final String doctor;
  final String patient;
  final DateTime? usedAt;

  Prescription(
      {required this.drug,
      required this.presentation,
      required this.quantity,
      required this.doctor,
      required this.patient,
      required this.usedAt});

  factory Prescription.fromApiResponse(ApiResponse<dynamic> response) {
    final data = response.body;

    final prescription = Prescription(
      drug: data['presentation']['drug']['name'],
      presentation: data['presentation']['name'],
      quantity: data['quantity'],
      doctor: data['doctor']['user']['name'] +
          ' ' +
          data['doctor']['user']['lastName'],
      patient: data['patient']['name'] + ' ' + data['patient']['lastName'],
      usedAt: data['usedAt'] != null ? DateTime.parse(data['usedAt']) : null,
    );

    return prescription;
  }

  factory Prescription.fromJson(Map<String, dynamic> data) {
    final prescription = Prescription(
      drug: data['presentation']['drug']['name'] +
          ' ' +
          data['presentation']['commercialName'],
      presentation: data['presentation']['name'],
      quantity: data['quantity'],
      doctor: data['doctor']['user']['name'] +
          ' ' +
          data['doctor']['user']['lastName'],
      patient: data['patient']['name'] + ' ' + data['patient']['lastName'],
      usedAt: data['usedAt'] != null ? DateTime.parse(data['usedAt']) : null,
    );

    return prescription;
  }
}
