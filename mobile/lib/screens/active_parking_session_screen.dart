import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/bottom_navigation.dart';
import 'package:mobile/screens/payment_successful_screen.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/parking_service.dart';
import 'package:mobile/models/parking_session_model.dart';
import 'package:intl/intl.dart';

class ActiveParkingSessionScreen extends StatefulWidget {
  const ActiveParkingSessionScreen({super.key});

  @override
  State<ActiveParkingSessionScreen> createState() => _ActiveParkingSessionScreenState();
}

class _ActiveParkingSessionScreenState extends State<ActiveParkingSessionScreen> {
  final AuthService _authService = AuthService();
  final ParkingService _parkingService = ParkingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: _authService.currentUser == null 
            ? const Center(child: Text('Not logged in'))
            : StreamBuilder<List<ParkingSessionModel>>(
                stream: _parkingService.getUserActiveSessions(_authService.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return ListView(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 60),
                        const Center(child: Text('No active parking session found.', style: TextStyle(fontSize: 16))),
                      ]
                    );
                  }

                  final session = snapshot.data!.first;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 16),
                        _buildTicketCard(session),
                        const SizedBox(height: 16),
                        _buildDurationCard(session.entryTime),
                        const SizedBox(height: 20),
                        _buildExitButton(context, session),
                      ],
                    ),
                  );
                },
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
  Widget _buildTicketCard(ParkingSessionModel session) {
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
                children: [
                  const Text('User ID', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    session.userId.length > 8 ? 'USR-${session.userId.substring(0, 8)}' : session.userId,
                    style: const TextStyle(
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
              value: DateFormat('MMM d, yyyy').format(session.entryTime),
              icon2: Icons.access_time,
              title2: 'Entry Time',
              value2: DateFormat('h:mm a').format(session.entryTime),
            ),
            const Divider(height: 1),
            _singleInfo(
              icon: Icons.confirmation_number,
              title: 'Ticket Number',
              value: session.ticketNumber,
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
  Widget _buildDurationCard(DateTime entryTime) {
    final diff = DateTime.now().difference(entryTime);
    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    // Using seconds as static '00' or similar because updating real-time requires a ticker.
    
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
              children: [
                _TimeBox(hours, 'Hours'),
                _TimeBox(minutes, 'Minutes'),
                const _TimeBox('--', 'Seconds'), // Static for simplicity without Ticker
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isExiting = false;

  // ---------------- EXIT BUTTON ----------------
  Widget _buildExitButton(BuildContext context, ParkingSessionModel session) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isExiting ? null : () async {
            setState(() => _isExiting = true);
            try {
              await _parkingService.endSession(session.sessionId, 'user_exit_scan', 'PAID');
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentSuccessfulScreen()),
                );
              }
            } catch (e) {
               if (mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to exit: $e'), backgroundColor: Colors.red));
               }
            } finally {
               if (mounted) setState(() => _isExiting = false);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: _isExiting 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Simulate Exit & Pay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                ),
        ),
      ),
    );
  }
}

// ---------------- TIME BOX ----------------
class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
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
