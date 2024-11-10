import 'package:emed/src/services/api/api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../components/qr_scanner.dart';

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
      context.push('/prescription/${barcode.displayValue}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Escanee un codigo QR',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 5,
          child: QRScanner(
            handleQR: handleQR,
          ),
        ),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text('Escanea un código'),
          ),
        )
      ],
    );
  }
}
