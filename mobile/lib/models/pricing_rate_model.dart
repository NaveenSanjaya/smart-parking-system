import 'package:cloud_firestore/cloud_firestore.dart';

class PricingRateModel {
  final String rateId;
  final double hourlyRate;
  final double dailyRate;
  final DateTime effectiveDate;
  final String updatedByAdmin;

  PricingRateModel({
    required this.rateId,
    required this.hourlyRate,
    required this.dailyRate,
    required this.effectiveDate,
    required this.updatedByAdmin,
  });

  factory PricingRateModel.fromJson(Map<String, dynamic> json, String documentId) {
    return PricingRateModel(
      rateId: documentId,
      hourlyRate: (json['hourlyRate'] ?? 0.0).toDouble(),
      dailyRate: (json['dailyRate'] ?? 0.0).toDouble(),
      effectiveDate: (json['effectiveDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedByAdmin: json['updatedByAdmin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hourlyRate': hourlyRate,
      'dailyRate': dailyRate,
      'effectiveDate': Timestamp.fromDate(effectiveDate),
      'updatedByAdmin': updatedByAdmin,
    };
  }
}
