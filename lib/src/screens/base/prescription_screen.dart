import 'package:emed/src/services/prescription/prescription.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PrescriptionScreen extends StatefulWidget {
  final String prescriptionId;
  final PrescriptionService prescriptionService;

  static const routeName = '/prescription';

  const PrescriptionScreen({
    Key? key,
    required this.prescriptionId,
    required this.prescriptionService,
  }) : super(key: key);

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  Future<void> _markPrescriptionAsUsed() async {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          widget.prescriptionService.fetchPrescription(widget.prescriptionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var childrenWidgets = <Widget>[];

        if (snapshot.hasError) {
          childrenWidgets.add(
            const Center(
              child: Text(
                'La receta no es valida.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          childrenWidgets.add(
            const Center(
              child: Text(
                'No se encontró la receta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          final prescriptionData = snapshot.data!;
          childrenWidgets = [
            _buildSectionTitle('Receta'),
            _buildDetailRow('Nombre',
                '${prescriptionData.presentation.drugName} ${prescriptionData.presentation.name}'),
            _buildDetailRow('Nombre comercial',
                prescriptionData.presentation.commercialName),
            _buildDetailRow(
                'Forma farmacéutica', prescriptionData.presentation.form),
            _buildDetailRow(
                'Cantidad de unidades', prescriptionData.quantity.toString()),
            _buildDetailRow('Diagnóstico', prescriptionData.indication),
            _buildDetailRow(
                'Fecha de emision',
                DateFormat('dd/MM/yyyy').format(
                  prescriptionData.emitedAt,
                )),
            const Divider(),
            _buildSectionTitle('Profesional'),
            _buildDetailRow(
                'Nombre completo', prescriptionData.doctor.fullName),
            _buildDetailRow('Especialidad', prescriptionData.doctor.specialty),
            _buildDetailRow('Licencia', prescriptionData.doctor.license),
            const Divider(),
            _buildSectionTitle('Paciente'),
            _buildDetailRow(
                'Nombre completo', prescriptionData.patient.fullName),
            _buildDetailRow(
                'Plan de seguro', prescriptionData.patient.insuranceCompany),
            _buildDetailRow(
              'Fecha de nacimiento',
              DateFormat('dd/MM/yyyy').format(
                prescriptionData.patient.birthDate,
              ),
            ),
            _buildDetailRow('Sexo', prescriptionData.patient.sex),
            _buildDetailRow('DNI', prescriptionData.patient.dni.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: prescriptionData.used
                  ? null
                  : () => _markPrescriptionAsUsed(),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    prescriptionData.used ? Colors.grey : Colors.blue,
              ),
              child: Text(
                  prescriptionData.used ? 'Receta usada' : 'Marcar como usada'),
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
