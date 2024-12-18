import 'dart:async';

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
  final MobileScannerController controller = MobileScannerController();

  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(handleQR);

    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(handleQR);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasScanned = false;
  }

  void handleQR(BarcodeCapture? barcode) async {
    if (!_hasScanned && barcode != null && barcode.barcodes.isNotEmpty) {
      _hasScanned = true;
      unawaited(_subscription?.cancel());
      _subscription = null;
      unawaited(controller.stop());
      context.go('/prescription/${barcode.barcodes[0].displayValue}/verify');
      if (mounted) {
        setState(() {
          _hasScanned = false;
          controller.start();
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
            controller: controller,
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
