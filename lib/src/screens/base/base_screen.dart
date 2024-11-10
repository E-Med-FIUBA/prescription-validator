import 'package:emed/src/screens/base/indexes.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile_controller.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile_view.dart';
import 'package:emed/src/screens/base/prescription_history_screen.dart';
import 'package:emed/src/screens/base/prescription_metrics.dart';
import 'package:emed/src/screens/base/qr_scanner_screen.dart';
import 'package:emed/src/services/api/api.dart';
import 'package:emed/src/settings/settings_controller.dart';
import 'package:emed/src/settings/settings_view.dart';
import 'package:emed/src/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseScreen extends StatefulWidget {
  final SettingsController settingsController;
  final PharmacistProfileController profileController;
  final int selectedIndex;

  final ApiService apiService;

  const BaseScreen({
    super.key,
    required this.settingsController,
    required this.profileController,
    required this.selectedIndex,
    required this.apiService,
  });

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case indexPrescriptionHistory:
        return const PrescriptionHistoryScreen();
      case indexPrescriptionMetrics:
        return const PrescriptionMetricsScreen();
      case indexQRScanner:
        return QRScannerScreen(
          apiService: widget.apiService,
        );
      case indexPharmacistProfile:
        return PharmacistProfileView(controller: widget.profileController);
      case indexSettings:
        return SettingsView(controller: widget.settingsController);
      default:
        return PharmacistProfileView(controller: widget.profileController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
