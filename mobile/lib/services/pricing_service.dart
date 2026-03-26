import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pricing_rate_model.dart';

class PricingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current active pricing rate (assuming there's one document or we order by effectiveDate)
  Future<PricingRateModel?> getCurrentPricingRate() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('pricing_rates')
          .orderBy('effectiveDate', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return PricingRateModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch pricing rate: $e');
    }
  }

  // Admin: update/create pricing rate
  Future<void> addPricingRate(PricingRateModel rate) async {
    try {
      await _firestore.collection('pricing_rates').add(rate.toJson());
    } catch (e) {
      throw Exception('Failed to add pricing rate: $e');
    }
  }
}
