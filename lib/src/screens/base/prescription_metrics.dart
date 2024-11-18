import 'package:emed/src/services/prescription/classes/prescription_metrics.dart';
import 'package:emed/src/services/prescription/prescription.service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PrescriptionMetricsScreen extends StatefulWidget {
  final PrescriptionService prescriptionService;

  static String routeName = '/prescription-metrics';

  PrescriptionMetricsScreen({
    Key? key,
    required this.prescriptionService,
  }) : super(key: key);

  @override
  State<PrescriptionMetricsScreen> createState() =>
      _PrescriptionMetricsScreenState();
}

class _PrescriptionMetricsScreenState extends State<PrescriptionMetricsScreen> {
  late Future<PrescriptionMetricsData> _metricsData;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  void _loadMetrics() {
    _metricsData = widget.prescriptionService.fetchPrescriptionMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: SingleChildScrollView(
        // Added ScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Added to prevent unnecessary expansion
            children: [
              const Text(
                'Métricas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              FutureBuilder<PrescriptionMetricsData>(
                future: _metricsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final data = snapshot.data!;

                  if (data.topDrugs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Valide mas recetas para visualizar metricas',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize
                        .min, // Added to prevent unnecessary expansion
                    children: [
                      SizedBox(
                        // Wrapped chart in SizedBox with fixed height
                        height: 300,
                        child: _buildTopDrugsChart(data.topDrugs),
                      ),
                      const SizedBox(height: 24),
                      _buildMetricsGrid(data),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopDrugsChart(List<DrugUsage> topDrugs) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust bar width based on available space
        final barWidth =
            (constraints.maxWidth / (topDrugs.length * 2)).clamp(15.0, 30.0);
        // Calculate bottom title space needed
        final reservedBottomSpace = 80.0; // Increased space for labels

        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: topDrugs.map((e) => e.count).reduce((a, b) => a > b ? a : b) *
                1.2,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                      '${topDrugs[group.x.toInt()].name}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: rod.toY.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                      textDirection: TextDirection.ltr);
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: reservedBottomSpace,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= topDrugs.length) return const Text('');
                    // Calculate available width per label
                    final labelWidth = constraints.maxWidth / topDrugs.length;
                    final fontSize = (labelWidth * 0.2)
                        .clamp(9.0, 12.0); // Responsive font size

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Transform.rotate(
                        angle: 45 * 3.141592 / 180,
                        child: SizedBox(
                          width: labelWidth,
                          child: Text(
                            topDrugs[value.toInt()].name,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.2)),
                left: BorderSide(color: Colors.black.withOpacity(0.2)),
              ),
            ),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 50,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  strokeWidth: 1,
                );
              },
            ),
            barGroups: topDrugs.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.count.toDouble(),
                    color: Colors.blue.shade400,
                    width: barWidth,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMetricsGrid(PrescriptionMetricsData data) {
    return LayoutBuilder(
      // Added LayoutBuilder for responsive grid
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent nested scrolling
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _buildMetricCard(
              'Total de Prescriptores',
              data.totalPrescriptions.toString(),
              Icons.medical_services,
            ),
            _buildMetricCard(
              'Média Diária',
              data.averageDailyPrescriptions.toStringAsFixed(1),
              Icons.calendar_today,
            ),
            _buildMetricCard(
              'Pacientes Únicos',
              data.uniquePatients.toString(),
              Icons.people,
            ),
            _buildMetricCard(
              'Médicos Prescritores',
              data.uniqueDoctors.toString(),
              Icons.local_hospital,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
