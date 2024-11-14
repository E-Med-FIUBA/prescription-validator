import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/prescription/prescription.service.dart';
import '../../utils/scaffold_messenger.dart';

class PrescriptionScreen extends StatefulWidget {
  final String prescriptionId;

  static const routeName = '/prescription';

  final PrescriptionService prescriptionService;

  PrescriptionScreen(
      {required this.prescriptionId, required this.prescriptionService});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  late Future<Prescription?> prescription;

  @override
  void initState() {
    super.initState();
    prescription = fetchPrescription(widget.prescriptionId);
  }

  Future<Prescription?> fetchPrescription(String id) async {
    try {
      final response = await widget.prescriptionService.fetchPrescription(id);
      return response;
    } catch (err) {
      showMessage('Error al cargar la receta', context);
    }
    return null;
  }

  Future<void> markAsUsed(String id) async {
    try {
      await widget.prescriptionService.markAsUsed(id);
      showMessage('Receta marcada como usada', context);
      context.go('/');
    } catch (err) {
      showMessage('Error al marcar la receta como usada', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Prescription?>(
      future: prescription,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No se encontraron datos'));
        } else {
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medicamento: ${data.drug}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('Presentación: ${data.presentation}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text('Cantidad: ${data.quantity}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text('Doctor: ${data.doctor}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await markAsUsed(widget.prescriptionId);
                      },
                      child: const Text('Marcar como usada'),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
