import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _historyData = [
    {
      'ticketId': 'TKT-2025-120478',
      'date': 'Dec 7, 2025',
      'time': '10:45 AM - 12:47 PM',
      'duration': '2h 2m',
      'amount': 9.00,
      'status': 'PAID',
    },
    {
      'ticketId': 'TKT-2025-120401',
      'date': 'Dec 6, 2025',
      'time': '3:20 PM - 5:15 PM',
      'duration': '1h 55m',
      'amount': 8.50,
      'status': 'PAID',
    },
    {
      'ticketId': 'TKT-2025-120356',
      'date': 'Dec 5, 2025',
      'time': '9:00 AM - 12:30 PM',
      'duration': '3h 30m',
      'amount': 14.00,
      'status': 'PAID',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _historyData.length,
              itemBuilder: (context, index) {
                final item = _historyData[index];
                return _buildHistoryCard(item);
              },
            ),
          ),
          _buildSummary(),
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
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
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

  Widget _buildHistoryCard(Map<String, dynamic> item) {
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
                Text(
                  item['ticketId'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        item['status'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
                  item['date'],
                  style: const TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(Icons.access_time, 'Time', item['time']),
                _buildDetailItem(null, 'Duration', item['duration']),
                _buildDetailItem(
                  Icons.attach_money,
                  'Amount',
                  '\$${item['amount'].toStringAsFixed(2)}',
                  isAmount: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData? icon, String label, String value, {bool isAmount = false}) {
    return Column(
      crossAxisAlignment: isAmount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF007980),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Total Sessions', style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(
                  '6', // Dummy data matching the list/context
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Total Spent', style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(
                  '\$59.00', // Dummy data
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
