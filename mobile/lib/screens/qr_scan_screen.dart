import 'package:flutter/material.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/parking_service.dart';
import 'package:mobile/screens/active_parking_session_screen.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0B1220),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),

            // Top buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleIcon(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  _circleIcon(
                    icon: Icons.flashlight_on_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _cameraFrame(),
                  const SizedBox(height: 24),
                  const Text(
                    'Scan Entry QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const SizedBox(height: 6),
                  const Text(
                    'Position the QR code within the frame',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 40,
              left: 40,
              right: 40,
              child: ElevatedButton(
                onPressed: () => _simulateScan(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Simulate Scan Entry QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _cameraFrame() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Stack(
        children: [
          _corner(top: 0, left: 0),
          _corner(top: 0, right: 0),
          _corner(bottom: 0, left: 0),
          _corner(bottom: 0, right: 0),
          Center(
            child: Text(
              'CAMERA VIEW',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border(
            top: top != null ? const BorderSide(color: Colors.blue, width: 3) : BorderSide.none,
            bottom: bottom != null ? const BorderSide(color: Colors.blue, width: 3) : BorderSide.none,
            left: left != null ? const BorderSide(color: Colors.blue, width: 3) : BorderSide.none,
            right: right != null ? const BorderSide(color: Colors.blue, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _simulateScan(BuildContext context) async {
    final AuthService _authService = AuthService();
    final ParkingService _parkingService = ParkingService();

    try {
      final user = _authService.currentUser;
      if (user != null) {
        // Mocking a slot scan
        await _parkingService.createSession(user.uid, 'slot_demo_1', 'user');
        if (context.mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ActiveParkingSessionScreen()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not logged in.'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scan Error: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
