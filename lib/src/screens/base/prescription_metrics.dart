import 'package:flutter/material.dart';

class PrescriptionMetricsScreen extends StatelessWidget {
  const PrescriptionMetricsScreen({super.key});

  static const routeName = '/prescription/metrics';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Title',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Métricas de Recetas'),
        ],
      ),
    );
  }
}
