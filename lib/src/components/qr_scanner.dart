import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatelessWidget {
  final Function(Barcode?) handleQR;
  final MobileScannerController? controller;

  const QRScanner({
    Key? key,
    required this.handleQR,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          handleQR(barcodes.first);
        }
      },
    );
  }
}
