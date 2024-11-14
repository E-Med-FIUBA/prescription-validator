import 'package:flutter/material.dart';

import '../../services/pharmacist/pharmacist.service.dart';
import 'pharmacist_profile.service.dart';

class PharmacistProfileController with ChangeNotifier {
  PharmacistProfileController(this._profileService);

  final PharmacistProfileService _profileService;

  Future<void> logout() async {
    await _profileService.logout();
    notifyListeners();
  }

  Future<Pharmacist> getPharmacist() async {
    return _profileService.getPharmacist();
  }
}
