import 'package:emed/src/services/prescription/prescription.service.dart';
import 'package:emed/src/utils/scaffold_messenger.dart';
import 'package:flutter/material.dart';

class PrescriptionHistoryScreen extends StatefulWidget {
  final PrescriptionService prescriptionService;

  PrescriptionHistoryScreen({required this.prescriptionService});

  static String routeName = '/';

  @override
  _PrescriptionHistoryScreenState createState() =>
      _PrescriptionHistoryScreenState();
}

class _PrescriptionHistoryScreenState extends State<PrescriptionHistoryScreen> {
  late Future<List<Prescription>> _prescriptionHistoryFuture;

  @override
  void initState() {
    super.initState();
    _prescriptionHistoryFuture = _fetchPrescriptionHistory();
  }

  Future<List<Prescription>> _fetchPrescriptionHistory() async {
    try {
      return await widget.prescriptionService.fetchPrescriptionHistory();
    } catch (e) {
      showMessage('Failed to load prescription history', context);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prescription>>(
      future: _prescriptionHistoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load prescription history'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No se encontraron recetas.'));
        } else {
          final prescriptions = snapshot.data!;
          return ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = prescriptions[index];
              return Card(
                child: ListTile(
                  title:
                      Text('${prescription.drug} (x${prescription.quantity})'),
                  subtitle: Text(
                    'Patient: ${prescription.patient}\n'
                    'Doctor: ${prescription.doctor}\n'
                    'Used: ${prescription.usedAt.toIso8601String()}',
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
