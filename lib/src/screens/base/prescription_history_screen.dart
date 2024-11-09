import 'package:flutter/material.dart';

class PrescriptionHistoryScreen extends StatelessWidget {
  const PrescriptionHistoryScreen({super.key});

  static const routeName = '/prescription/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Recetas'),
      ),
      body: const Center(
        child: Text('Historial de Recetas'),
      ),
    );
  }
}
