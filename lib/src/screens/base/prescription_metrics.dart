import 'package:flutter/material.dart';

class PrescriptionMetricsScreen extends StatelessWidget {
  const PrescriptionMetricsScreen({super.key});

  static const routeName = '/prescription/metrics';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métricas de Recetas'),
      ),
      body: const Center(
        child: Text('Métricas de Recetas'),
      ),
    );
  }
}
