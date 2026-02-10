import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/bottom_navigation.dart';
import 'package:mobile/screens/payment_successful_screen.dart';

class ActiveParkingSessionScreen extends StatelessWidget {
  const ActiveParkingSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildTicketCard(),
              const SizedBox(height: 16),
              _buildDurationCard(),
              const SizedBox(height: 20),
              _buildExitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BottomNavigation()),
                (route) => false,
              );
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white),
                SizedBox(width: 6),
                Text('Back', style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Active Parking Session',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Keep this ticket for exit', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // ---------------- TICKET CARD ----------------
  Widget _buildTicketCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.teal,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('User ID', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 6),
                  Text(
                    'USR-2024-8472',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _infoRow(
              icon: Icons.calendar_today,
              title: 'Entry Date',
              value: 'Dec 7, 2025',
              icon2: Icons.access_time,
              title2: 'Entry Time',
              value2: '10:45 AM',
            ),
            const Divider(height: 1),
            _singleInfo(
              icon: Icons.confirmation_number,
              title: 'Ticket Number',
              value: 'TKT-2025-120478',
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: Icon(Icons.qr_code, size: 120, color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Scan this code at exit gate',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    required IconData icon2,
    required String title2,
    required String value2,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _infoItem(icon, title, value)),
          Expanded(child: _infoItem(icon2, title2, value2)),
        ],
      ),
    );
  }

  static Widget _singleInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(padding: const EdgeInsets.all(16), child: _infoItem(icon, title, value));
  }

  static Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  // ---------------- DURATION CARD ----------------
  Widget _buildDurationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text(
              'Parking Duration',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _timeBox('00', 'Hours'),
                _timeBox('02', 'Minutes'),
                _timeBox('31', 'Seconds'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- EXIT BUTTON ----------------
  Widget _buildExitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentSuccessfulScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text(
            'Proceed to Exit',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ---------------- TIME BOX ----------------
class _timeBox extends StatelessWidget {
  final String value;
  final String label;

  const _timeBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
