import 'package:emed/src/services/api/api.dart';

class Doctor {
  final String fullName;
  final String specialty;
  final String license;

  Doctor({
    required this.fullName,
    required this.specialty,
    required this.license,
  });

  factory Doctor.fromJson(Map<String, dynamic> data) {
    final doctor = Doctor(
      fullName: "${data['user']['name']} ${data['user']['lastName']}",
      specialty: data['specialty']['name'],
      license: data['license'],
    );
    return doctor;
  }
}

class Presentation {
  final String name;
  final String commercialName;
  final String drugName;
  final String atc;
  final String form;

  Presentation({
    required this.name,
    required this.commercialName,
    required this.drugName,
    required this.atc,
    required this.form,
  });

  factory Presentation.fromJson(Map<String, dynamic> data) {
    String cleanString(String str) {
      return str.replaceAll(RegExp(r"[\[\]{}\'`()]"), '');
    }

    final presentation = Presentation(
      name: data['name'],
      commercialName: data['commercialName'],
      drugName: data['drug']['name'],
      atc: data['drug']['atc'],
      form: cleanString(data['form']),
    );
    return presentation;
  }
}

class Patient {
  final String fullName;
  final String sex;
  final int dni;
  final String insuranceCompany;
  final DateTime birthDate;

  Patient({
    required this.fullName,
    required this.sex,
    required this.dni,
    required this.insuranceCompany,
    required this.birthDate,
  });

  static const sexMap = {
    'MALE': 'Masculino',
    'FEMALE': 'Femenino',
    'OTHER': 'Otro',
  };

  factory Patient.fromJson(Map<String, dynamic> data) {
    final patient = Patient(
      fullName: "${data['name']} ${data['lastName']}",
      sex: sexMap[data['sex']] ?? 'Otro',
      dni: data['dni'],
      insuranceCompany: data['insuranceCompany']['name'],
      birthDate: DateTime.parse(data['birthDate']),
    );
    return patient;
  }
}

class VerifiedPrescription {
  final int id;
  final String indication;
  final DateTime emitedAt;
  final int quantity;
  final Patient patient;
  final Doctor doctor;
  final Presentation presentation;
  final bool used;

  VerifiedPrescription({
    required this.id,
    required this.indication,
    required this.emitedAt,
    required this.quantity,
    required this.patient,
    required this.doctor,
    required this.presentation,
    required this.used,
  });

  factory VerifiedPrescription.fromApiResponse(ApiResponse response) {
    final data = response.body;
    return VerifiedPrescription(
      id: data['id'],
      indication: data['indication'],
      emitedAt: DateTime.parse(data['emitedAt']),
      quantity: data['quantity'],
      patient: Patient.fromJson(data['patient']),
      doctor: Doctor.fromJson(data['doctor']),
      presentation: Presentation.fromJson(data['presentation']),
      used: data['used'],
    );
  }
}
