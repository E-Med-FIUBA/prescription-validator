import 'dart:developer';

import '../api/api.dart';

class PharmacistService {
  final ApiService _apiService;

  PharmacistService(this._apiService);

  Future<Pharmacist> fetchPharmacist() async {
    try {
      final response = await _apiService.get('users/me');

      if (response.statusCode == 200) {
        return Pharmacist.fromApiResponse(response);
      } else {
        throw Exception('Failed to load Pharmacist');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load Pharmacist');
    }
  }
}

class Pharmacist {
  final String name;
  final String lastName;
  final String email;
  final int dni;
  final String license;

  Pharmacist({
    required this.name,
    required this.lastName,
    required this.email,
    required this.dni,
    required this.license,
  });

  factory Pharmacist.fromApiResponse(ApiResponse<dynamic> response) {
    final data = response.body;

    return Pharmacist(
      name: data['name'],
      lastName: data['lastName'],
      email: data['email'],
      dni: data['dni'],
      license: data['pharmacist']['license'],
    );
  }
}
