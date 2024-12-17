import 'package:emed/src/services/prescription/prescription.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PrescriptionScreen extends StatefulWidget {
  final String prescriptionId;
  final PrescriptionService prescriptionService;
  final bool verify;

  static const routeName = '/prescription';

  const PrescriptionScreen(
      {super.key,
      required this.prescriptionId,
      required this.prescriptionService,
      required this.verify});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  bool _isLoading = false;

  Future<void> _markPrescriptionAsUsed() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.prescriptionService.markAsUsed(widget.prescriptionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receta marcada como usada')),
      );
      context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al marcar la receta: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Receta'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: FutureBuilder(
          future: widget.prescriptionService
              .fetchPrescription(widget.prescriptionId, widget.verify),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var childrenWidgets = <Widget>[];

            if (snapshot.hasError) {
              debugPrint('Error: ${snapshot.error}');
              childrenWidgets.add(
                Center(
                  child: Text(
                    'La receta no es valida.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              childrenWidgets.add(
                Center(
                  child: Text(
                    'No se encontró la receta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              final prescriptionData = snapshot.data!;
              childrenWidgets = [
                buildSectionTitle('Receta', colorScheme.primary),
                buildDetailRow('Nombre',
                    '${prescriptionData.presentation.drugName} ${prescriptionData.presentation.name}'),
                buildDetailRow('Nombre comercial',
                    prescriptionData.presentation.commercialName),
                buildDetailRow(
                    'Forma farmacéutica', prescriptionData.presentation.form),
                buildDetailRow('Cantidad de unidades',
                    prescriptionData.quantity.toString()),
                buildDetailRow('Diagnóstico', prescriptionData.indication),
                buildDetailRow(
                    'Fecha de emision',
                    DateFormat('dd/MM/yyyy').format(
                      prescriptionData.emitedAt,
                    )),
                const Divider(),
                buildSectionTitle('Profesional', colorScheme.primary),
                buildDetailRow(
                    'Nombre completo', prescriptionData.doctor.fullName),
                buildDetailRow(
                    'Especialidad', prescriptionData.doctor.specialty),
                buildDetailRow('Licencia', prescriptionData.doctor.license),
                const Divider(),
                buildSectionTitle('Paciente', colorScheme.primary),
                buildDetailRow(
                    'Nombre completo', prescriptionData.patient.fullName),
                buildDetailRow('Plan de seguro',
                    prescriptionData.patient.insuranceCompany),
                buildDetailRow(
                  'Fecha de nacimiento',
                  DateFormat('dd/MM/yyyy').format(
                    prescriptionData.patient.birthDate,
                  ),
                ),
                buildDetailRow('Sexo', prescriptionData.patient.sex),
                buildDetailRow('DNI', prescriptionData.patient.dni.toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: prescriptionData.used || _isLoading
                      ? null
                      : () => _markPrescriptionAsUsed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: prescriptionData.used
                        ? colorScheme.onSurface
                        : colorScheme.primary,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary),
                        )
                      : Text(
                          prescriptionData.used
                              ? 'Receta usada'
                              : 'Marcar como usada',
                          style: TextStyle(color: colorScheme.onPrimary)),
                )
              ];
            }

            return Card(
              elevation: 4,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/logo.svg'),
                    const SizedBox(height: 16),
                    ...childrenWidgets,
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
