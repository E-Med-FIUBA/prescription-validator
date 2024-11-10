import 'package:emed/src/services/api/api.dart';
import 'package:emed/src/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../components/qr_scanner.dart';
import 'prescription_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key, required this.apiService});

  static const routeName = '/qr-scanner';

  final ApiService apiService; // Initialize the apiService

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _hasScanned = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasScanned = false;
  }

  void handleQR(Barcode? barcode) {
    if (!_hasScanned && barcode != null && barcode.displayValue != null) {
      _hasScanned = true;
      navigate(PrescriptionScreen.routeName, context, arguments: {
        'barcode': barcode.displayValue,
        'apiService': widget.apiService
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRScanner(
              handleQR: handleQR,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }
}
