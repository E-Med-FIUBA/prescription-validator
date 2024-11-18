import 'package:emed/src/services/api/api.dart';

class PrescriptionMetricsData {
  final List<DrugUsage> topDrugs;
  final int totalPrescriptions;
  final double averageDailyPrescriptions;
  final int uniquePatients;
  final int uniqueDoctors;

  PrescriptionMetricsData({
    required this.topDrugs,
    required this.totalPrescriptions,
    required this.averageDailyPrescriptions,
    required this.uniquePatients,
    required this.uniqueDoctors,
  });

  factory PrescriptionMetricsData.fromApiResponse(
      ApiResponse<dynamic> response) {
    final data = response.body;
    return PrescriptionMetricsData(
      topDrugs: data['topDrugs']
          .map<DrugUsage>((drug) => DrugUsage(
                name: drug['name'],
                count: drug['count'],
              ))
          .toList(),
      totalPrescriptions: data['totalPrescriptions'],
      averageDailyPrescriptions: data['averageDailyPrescriptions'].toDouble(),
      uniquePatients: data['uniquePatients'],
      uniqueDoctors: data['uniqueDoctors'],
    );
  }
}

class DrugUsage {
  final String name;
  final int count;

  DrugUsage({
    required this.name,
    required this.count,
  });
}
