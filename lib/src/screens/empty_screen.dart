import 'package:emed/src/screens/qr_scanner_screen.dart';
import 'package:emed/src/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../utils/navigation.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    void navigateTo(int index) {
      switch (index) {
        case 0:
          navigate(const EmptyScreen(), context);
          break;
        case 2:
          navigate(const QRScannerScreen(), context);
          break;
        default:
          navigate(const EmptyScreen(), context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empty Screen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: Text(
            'Empty Screen Content',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex,
          onItemTapped: (index) => {navigateTo(index)}),
    );
  }
}
