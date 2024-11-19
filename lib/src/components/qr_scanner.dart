import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatelessWidget {
  final MobileScannerController? controller;

  const QRScanner({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
    );
  }
}
