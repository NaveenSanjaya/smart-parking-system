import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/models/parking_session_model.dart';
import 'package:mobile/models/pricing_rate_model.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/parking_service.dart';
import 'package:mobile/services/pricing_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AuthService _authService = AuthService();
  final ParkingService _parkingService = ParkingService();
  final PricingService _pricingService = PricingService();

  String _selectedFilter = 'All';
  PricingRateModel? _currentRate;

  @override
  void initState() {
    super.initState();
    _loadPricingRate();
  }

  Future<void> _loadPricingRate() async {
    try {
      final rate = await _pricingService.getCurrentPricingRate();
      if (mounted) setState(() => _currentRate = rate);
    } catch (_) {}
  }

  List<ParkingSessionModel> _applyFilter(List<ParkingSessionModel> sessions) {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'This Week':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return sessions
            .where((s) => s.entryTime.isAfter(
                DateTime(weekStart.year, weekStart.month, weekStart.day)))
            .toList();
      case 'This Month':
        return sessions
            .where((s) =>
                s.entryTime.year == now.year && s.entryTime.month == now.month)
            .toList();
      case 'This Year':
        return sessions
            .where((s) => s.entryTime.year == now.year)
            .toList();
      default:
        return sessions;
    }
  }

  String _formatDuration(DateTime entry, DateTime exit) {
    final diff = exit.difference(entry);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  double _calculateAmount(DateTime entry, DateTime exit) {
    final hourlyRate = _currentRate?.hourlyRate ?? 4.0;
    final hours = exit.difference(entry).inMinutes / 60.0;
    return double.parse((hours * hourlyRate).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 16),
          Expanded(
            child: userId == null
                ? const Center(child: Text('Not logged in'))
                : StreamBuilder<List<ParkingSessionModel>>(
                    stream: _parkingService.getUserSessionHistory(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final allSessions = snapshot.data ?? [];
                      final filtered = _applyFilter(allSessions);

                      if (filtered.isEmpty) return _buildEmptyState();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            _buildHistoryCard(filtered[index]),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Parking History',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'View your past parking sessions',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 12),
          _buildFilterChip('This Week'),
          const SizedBox(width: 12),
          _buildFilterChip('This Month'),
          const SizedBox(width: 12),
          _buildFilterChip('This Year'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0B2544) : const Color(0xFF007980),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_parking_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No parking sessions yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your parking history will appear here\nonce you start parking.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(ParkingSessionModel session) {
    final exitTime = session.exitTime ?? DateTime.now();
    final duration = _formatDuration(session.entryTime, exitTime);
    final amount = _calculateAmount(session.entryTime, exitTime);
    final isPaid = session.paymentStatus == 'PAID';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    session.ticketNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isPaid ? Colors.green : Colors.orange),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPaid ? Icons.check_circle_outline : Icons.pending_outlined,
                        size: 14,
                        color: isPaid ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session.paymentStatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPaid ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM d, yyyy').format(session.entryTime),
                  style: const TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  Icons.access_time,
                  'Entry',
                  DateFormat('h:mm a').format(session.entryTime),
                ),
                _buildDetailItem(
                  Icons.exit_to_app,
                  'Exit',
                  DateFormat('h:mm a').format(exitTime),
                ),
                _buildDetailItem(
                  null,
                  'Duration',
                  duration,
                ),
                _buildDetailItem(
                  Icons.attach_money,
                  'Amount',
                  '\$${amount.toStringAsFixed(2)}',
                  isAmount: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData? icon, String label, String value,
      {bool isAmount = false}) {
    return Column(
      crossAxisAlignment:
          isAmount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
            ],
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}
