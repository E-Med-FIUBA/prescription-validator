import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../components/qr_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  static const routeName = '/qr-scanner';

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with WidgetsBindingObserver {
  bool _hasScanned = false;
  MobileScannerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.paused) {
      _controller?.stop();
    } else if (state == AppLifecycleState.resumed) {
      _controller?.start();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasScanned = false;
  }

  void handleQR(Barcode? barcode) async {
    if (!_hasScanned && barcode != null && barcode.displayValue != null) {
      _hasScanned = true;
      _controller?.stop(); // Stop scanning before navigation
      await context.push('/prescription/${barcode.displayValue}');
      // Optional: restart scanner if user comes back to this screen
      if (mounted) {
        setState(() {
          _hasScanned = false;
          _controller?.start();
        });
      }
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
            controller:
                _controller, // Pass the controller to your QRScanner widget
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
