import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/models/pricing_rate_model.dart';
import 'package:mobile/services/pricing_service.dart';

class ViewRatesScreen extends StatefulWidget {
  const ViewRatesScreen({super.key});

  @override
  State<ViewRatesScreen> createState() => _ViewRatesScreenState();
}

class _ViewRatesScreenState extends State<ViewRatesScreen> {
  final PricingService _pricingService = PricingService();
  PricingRateModel? _rate;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    try {
      final rate = await _pricingService.getCurrentPricingRate();
      if (mounted) {
        setState(() {
          _rate = rate;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        elevation: 0,
        title: const Text('Parking Rates', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadRates();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      const Text('Failed to load rates', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      TextButton(onPressed: _loadRates, child: const Text('Retry')),
                    ],
                  ),
                )
              : _buildRatesList(_rate),
    );
  }

  Widget _buildRatesList(PricingRateModel? rate) {
    final hourly = rate?.hourlyRate ?? 4.0;
    final daily = rate?.dailyRate ?? 25.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (rate != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rates effective from: ${_formatDate(rate.effectiveDate)}',
                    style: const TextStyle(color: AppColors.teal, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        _buildRateCard(
          title: 'Hourly Rate',
          price: '\$${hourly.toStringAsFixed(2)}',
          unit: 'per hour',
          description: 'Standard rate for parking',
          icon: Icons.access_time,
          color: Colors.blue,
          isLive: true,
        ),
        const SizedBox(height: 16),
        _buildRateCard(
          title: 'Daily Rate',
          price: '\$${daily.toStringAsFixed(2)}',
          unit: 'per day',
          description: 'Maximum charge per 24-hour period',
          icon: Icons.calendar_today,
          color: Colors.orange,
          isLive: true,
        ),
        const SizedBox(height: 16),
        _buildRateCard(
          title: 'Weekly Pass',
          price: '\$${(daily * 6).toStringAsFixed(2)}',
          unit: 'per week',
          description: 'Unlimited parking for 7 days (6× daily rate)',
          icon: Icons.date_range,
          color: Colors.purple,
        ),
        const SizedBox(height: 16),
        _buildRateCard(
          title: 'Lost Ticket',
          price: '\$50.00',
          unit: 'flat fee',
          description: 'Fee for lost or damaged tickets',
          icon: Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildRateCard({
    required String title,
    required String price,
    required String unit,
    required String description,
    required IconData icon,
    required Color color,
    bool isLive = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      if (isLive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
                Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
