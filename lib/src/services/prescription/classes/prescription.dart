import 'package:emed/src/services/api/api.dart';

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
