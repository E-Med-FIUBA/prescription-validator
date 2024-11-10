import 'package:flutter/material.dart';

import '../../services/prescription/prescription.service.dart';
import '../../utils/scaffold_messenger.dart';

class PrescriptionScreen extends StatefulWidget {
  final String prescriptionId;

  static const routeName = '/prescription/detail';

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
      return await widget.prescriptionService.fetchPrescription(id);
    } catch (err) {
      showMessage('Failed to load prescription', context);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
      ),
      body: FutureBuilder<Prescription?>(
        future: prescription,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
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
                      Text('Drug: ${data.drug}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text('Presentation: ${data.presentation}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 12),
                      Text('Indication: ${data.indication}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 12),
                      Text('Quantity: ${data.quantity}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 12),
                      Text('Doctor: ${data.doctor}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
