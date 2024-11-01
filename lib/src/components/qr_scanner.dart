import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  final Function(Barcode?)? handleQR;

  const QRScanner({super.key, this.handleQR});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? qR;

  void _handleQR(BarcodeCapture qRs) {
    if (mounted && widget.handleQR != null) {
      widget.handleQR!(qRs.barcodes.firstOrNull);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleQR,
          )
        ],
      ),
    );
  }
}
