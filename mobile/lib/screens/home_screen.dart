import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/level_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _availabilityAnimation;

  final int availableSlots = 236;
  late String userId;

  final List<Map<String, dynamic>> parkingLevels = [
    {'level': 'Level 1', 'available': 45, 'total': 100},
    {'level': 'Level 2', 'available': 23, 'total': 100},
    {'level': 'Level 3', 'available': 67, 'total': 100},
  ];

  @override
  void initState() {
    super.initState();

    userId = _generateUserId();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _availabilityAnimation = IntTween(
      begin: 0,
      end: availableSlots,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  String _generateUserId() {
    final random = Random();
    return 'USR-2024-${1000 + random.nextInt(9000)}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
          label: const Text('Scan QR', style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 24),
              const Text(
                'Parking Levels',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              ...parkingLevels.map(_buildParkingLevelCard).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI Components ----------------

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('User ID', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(userId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              children: [
                const Text('Available Parking Slots', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: _availabilityAnimation,
                  builder: (context, child) {
                    return Text(
                      _availabilityAnimation.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                const Text(
                  'Updated: Just now',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingLevelCard(Map<String, dynamic> level) {
    final double progress = level['available'] / level['total'];

    return GestureDetector(
      onTap: () {
        // Pass the correct levelName to LevelDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LevelDetailScreen(levelName: level['level'])),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                  child: const Icon(Icons.directions_car, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(level['level'], style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text('${level['available']} / ${level['total']}'),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE5E1E6),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
