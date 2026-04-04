import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/models/parking_session_model.dart';
import 'package:mobile/models/pricing_rate_model.dart';
import 'package:mobile/screens/bottom_navigation.dart';
import 'package:intl/intl.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  final ParkingSessionModel session;
  final PricingRateModel? rate;

  const PaymentSuccessfulScreen({
    super.key,
    required this.session,
    this.rate,
  });

  // Calculate parking duration string
  String get _durationString {
    final exit = session.exitTime ?? DateTime.now();
    final diff = exit.difference(session.entryTime);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    if (h > 0) return '$h hour${h != 1 ? 's' : ''} $m minute${m != 1 ? 's' : ''}';
    return '$m minute${m != 1 ? 's' : ''}';
  }

  // Calculate hours as double for billing
  double get _hoursParked {
    final exit = session.exitTime ?? DateTime.now();
    return exit.difference(session.entryTime).inMinutes / 60.0;
  }

  double get _hourlyRate => rate?.hourlyRate ?? 4.0;
  double get _baseAmount => double.parse((_hoursParked * _hourlyRate).toStringAsFixed(2));
  double get _serviceFee => double.parse((_baseAmount * 0.05).toStringAsFixed(2)); // 5% service fee
  double get _totalAmount => double.parse((_baseAmount + _serviceFee).toStringAsFixed(2));

  @override
  Widget build(BuildContext context) {
    final exitTime = session.exitTime ?? DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSuccessHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTicketInfoCard(),
                  const SizedBox(height: 16),
                  _buildExitInfoCard(exitTime),
                  const SizedBox(height: 16),
                  _buildDurationCard(),
                  const SizedBox(height: 16),
                  _buildPaymentBreakdownCard(),
                  const SizedBox(height: 16),
                  _buildPaymentStatusCard(),
                  const SizedBox(height: 24),
                  _buildDoneButton(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 40),
      decoration: const BoxDecoration(
        color: Color(0xFF006400),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'Payment Successful',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thank you for parking with us',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.numbers, size: 16, color: Colors.black54),
                SizedBox(width: 8),
                Text('Ticket Number', style: TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              session.ticketNumber,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExitInfoCard(DateTime exitTime) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Exit Information', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            _buildRowItem(
              Icons.login,
              'Entry Time',
              DateFormat('MMM d, yyyy  h:mm a').format(session.entryTime),
            ),
            const SizedBox(height: 16),
            _buildRowItem(
              Icons.logout,
              'Exit Time',
              DateFormat('MMM d, yyyy  h:mm a').format(exitTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.black54),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.black54)),
          ],
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDurationCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.black54),
                SizedBox(width: 8),
                Text('Total Duration', style: TextStyle(color: Colors.black54)),
              ],
            ),
            Text(
              _durationString,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentBreakdownCard() {
    final hours = _hoursParked;
    final fullHours = hours.floor();
    final extraMinutes = ((hours - fullHours) * 60).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Breakdown', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          if (fullHours > 0)
            _buildPaymentRow(
              'Base Rate ($fullHours hr × \$${_hourlyRate.toStringAsFixed(2)})',
              '\$${(fullHours * _hourlyRate).toStringAsFixed(2)}',
            ),
          if (fullHours > 0) const SizedBox(height: 12),
          if (extraMinutes > 0)
            _buildPaymentRow(
              'Additional Time ($extraMinutes min)',
              '\$${(extraMinutes / 60 * _hourlyRate).toStringAsFixed(2)}',
            ),
          if (extraMinutes > 0) const SizedBox(height: 12),
          _buildPaymentRow('Service Fee (5%)', '\$${_serviceFee.toStringAsFixed(2)}'),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.attach_money, size: 20, color: Colors.black54),
                  SizedBox(width: 4),
                  Text('Amount Paid', style: TextStyle(color: Colors.black54, fontSize: 16)),
                ],
              ),
              Text(
                '\$${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black54)),
        ),
        Text(value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildPaymentStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Status',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Paid on Exit',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Text(
            session.paymentStatus,
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavigation()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text(
          'Done',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
