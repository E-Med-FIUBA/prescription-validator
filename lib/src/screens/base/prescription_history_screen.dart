import 'package:emed/src/services/prescription/classes/prescription.dart';
import 'package:emed/src/services/prescription/prescription.service.dart';
import 'package:emed/src/utils/scaffold_messenger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PrescriptionHistoryScreen extends StatefulWidget {
  final PrescriptionService prescriptionService;

  const PrescriptionHistoryScreen(
      {super.key, required this.prescriptionService});

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

  void _navigateToPrescriptionScreen(Prescription prescription) {
    context.push('/prescription/${prescription.id}');
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
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Historial de Recetas',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: prescriptions.isEmpty
                    ? Center(child: Text('No se encontraron recetas.'))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () =>
                                    _navigateToPrescriptionScreen(prescription),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16.0),
                                  title: Text(
                                    prescription.drug,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Unidades: ${prescription.quantity.toString()}\n'
                                      'Paciente: ${prescription.patient}\n'
                                      'Médico: ${prescription.doctor}\n'
                                      'Usado: ${DateFormat('dd/MM/yyyy').format(prescription.usedAt!)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }
      },
    );
  }
}
