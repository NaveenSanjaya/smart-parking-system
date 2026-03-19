import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class ViewRatesScreen extends StatelessWidget {
  const ViewRatesScreen({super.key});

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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRateCard(
            title: 'Hourly Rate',
            price: '\$4.00',
            unit: 'per hour',
            description: 'Standard rate for the first 2 hours',
            icon: Icons.access_time,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildRateCard(
            title: 'Daily Rate',
            price: '\$25.00',
            unit: 'per day',
            description: 'Maximum charge per 24-hour period',
            icon: Icons.calendar_today,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildRateCard(
            title: 'Weekly Pass',
            price: '\$150.00',
            unit: 'per week',
            description: 'Unlimited parking for 7 days',
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
      ),
    );
  }

  Widget _buildRateCard({
    required String title,
    required String price,
    required String unit,
    required String description,
    required IconData icon,
    required Color color,
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
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
