import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile_view.dart';
import 'package:emed/src/screens/base/prescription_history_screen.dart';
import 'package:emed/src/screens/base/prescription_metrics.dart';
import 'package:emed/src/screens/base/qr_scanner_screen.dart';
import 'package:emed/src/settings/settings_view.dart';
import 'package:emed/src/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final String location;

  BaseScreen({super.key, required this.child, required this.location});

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final List<String> tabs = [
    PrescriptionHistoryScreen.routeName,
    PrescriptionMetricsScreen.routeName,
    QRScannerScreen.routeName,
    PharmacistProfileView.routeName,
    SettingsView.routeName
  ];

  void _goOtherTab(BuildContext context, int index) {
    final String targetPath = tabs[index];
    if (widget.location != targetPath) {
      context.go(targetPath);
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
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(child: widget.child),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: tabs.indexOf(widget.location),
        onItemTapped: (index) {
          _goOtherTab(context, index);
        },
      ),
    );
  }
}
