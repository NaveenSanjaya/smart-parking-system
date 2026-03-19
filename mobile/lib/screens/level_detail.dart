import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/models/zone_model.dart';

class LevelDetailScreen extends StatefulWidget {
  final String levelName;

  const LevelDetailScreen({super.key, required this.levelName});

  @override
  State<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends State<LevelDetailScreen> {
  int currentZoneIndex = 0;
  String selectedVehicleType = 'car'; // default selected

  // Filter zones dynamically based on selected vehicle type
  List<Map<String, dynamic>> get filteredZones {
    switch (selectedVehicleType) {
      case 'car':
        return zones
            .firstWhere((l) => l['level'] == widget.levelName)['zones']
            .where((z) => z['name'] == 'Zone A')
            .toList();
      case 'bike':
        return zones
            .firstWhere((l) => l['level'] == widget.levelName)['zones']
            .where((z) => z['name'] == 'Zone B')
            .toList();
      case '3wheel':
        return zones
            .firstWhere((l) => l['level'] == widget.levelName)['zones']
            .where((z) => z['name'] == 'Zone C')
            .toList();
      default:
        return [];
    }
  }

  // Current zone getter
  Map<String, dynamic> get currentZone {
    final zones = filteredZones;
    if (zones.isEmpty) return {}; // fallback
    if (currentZoneIndex >= zones.length) currentZoneIndex = 0;
    return zones[currentZoneIndex];
  }

  // Slots in the current zone
  List<Map<String, dynamic>> get currentSlots {
    return List<Map<String, dynamic>>.from(currentZone['slots'] ?? []);
  }

  // Update _countAvailable to filter slots by selected type
  int _countAvailable(String type) {
    int count = 0;
    for (var zone in zones.firstWhere((l) => l['level'] == widget.levelName)['zones']) {
      // apply parking rules
      if (type == 'bike' || type == '3wheel') {
        if (!(zone['name'] == 'Zone B' || zone['name'] == 'Zone C')) continue;
      }
      count +=
          (zone['slots'] as List).where((s) => s['type'] == type && s['available'] == true).length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _zoneSelector(),
            const SizedBox(height: 16),
            _buildParkingLayout(),
            const SizedBox(height: 16),
            _buildLegend(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.levelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Parking Availability', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // VEHICLE STATS INSIDE HEADER
          Row(
            children: [
              _statCard(
                icon: Icons.directions_car,
                label: 'Cars',
                count: _countAvailable('car'),
                isActive: selectedVehicleType == 'car',
                onTap: () => setState(() => selectedVehicleType = 'car'),
              ),
              _statCard(
                icon: Icons.pedal_bike,
                label: 'Bikes',
                count: _countAvailable('bike'),
                isActive: selectedVehicleType == 'bike',
                onTap: () => setState(() => selectedVehicleType = 'bike'),
              ),
              _statCard(
                icon: Icons.electric_rickshaw,
                label: '3-Wheel',
                count: _countAvailable('3wheel'),
                isActive: selectedVehicleType == '3wheel',
                onTap: () => setState(() => selectedVehicleType = '3wheel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- VEHICLE STATS ----------------
  Widget _statCard({
    required IconData icon,
    required String label,
    required int count,
    bool isActive = false,
    required VoidCallback onTap, // make it clickable
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: isActive ? AppColors.primaryColor : Colors.white),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primaryColor : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(color: isActive ? AppColors.primaryColor : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- ZONE SELECTOR ----------------
  Widget _zoneSelector() {
    final zone = currentZone; // <- this is the correct inner zone map

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // LEFT ARROW
          // _zoneArrow(
          //   icon: Icons.chevron_left,
          //   enabled: currentZoneIndex > 0,
          //   onTap: () {
          //     setState(() => currentZoneIndex--);
          //   },
          // ),

          // CENTER INFO
          Expanded(
            child: Column(
              children: [
                Text(
                  zone['name'] ?? 'Zone ${currentZoneIndex + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${zone['slots'].where((s) => s['available'] == true).length} slots available',
                  style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 112, 112, 112)),
                ),
              ],
            ),
          ),

          // RIGHT ARROW
          // _zoneArrow(
          //   icon: Icons.chevron_right,
          //   enabled:
          //       currentZoneIndex <
          //       zones.firstWhere((l) => l['level'] == widget.levelName)['zones'].length - 1,
          //   onTap: () {
          //     setState(() => currentZoneIndex++);
          //   },
          // ),
        ],
      ),
    );
  }

  // ZONE ARROW BUTTON
  // Widget _zoneArrow({required IconData icon, required bool enabled, required VoidCallback onTap}) {
  //   return InkWell(
  //     onTap: enabled ? onTap : null,
  //     borderRadius: BorderRadius.circular(50),
  //     child: Container(
  //       width: 40,
  //       height: 40,
  //       decoration: BoxDecoration(
  //         color: enabled ? AppColors.primaryColor : Colors.grey.shade300,
  //         shape: BoxShape.circle,
  //       ),
  //       child: Icon(icon, color: enabled ? Colors.white : Colors.grey.shade600),
  //     ),
  //   );
  // }

  // ---------------- PARKING GRID ----------------
  Widget _buildParkingLayout() {
    final left = currentSlots.take(5).toList();
    final right = currentSlots.skip(5).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(child: _slotColumnFromData(left)),
          const SizedBox(width: 16),
          _entryExitColumn(),
          const SizedBox(width: 16),
          Expanded(child: _slotColumnFromData(right)),
        ],
      ),
    );
  }

  Widget _slotColumnFromData(List<Map<String, dynamic>> slots) {
    return Column(
      children:
          slots.map((slot) {
            final bool isAvailable = slot['available'];

            IconData slotIcon;
            switch (slot['type']) {
              case 'car':
                slotIcon = Icons.directions_car;
                break;
              case 'bike':
                slotIcon = Icons.pedal_bike;
                break;
              case '3wheel':
                slotIcon = Icons.electric_rickshaw;
                break;
              default:
                slotIcon = Icons.help;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 48,
              decoration: BoxDecoration(
                color: isAvailable ? AppColors.teal : const Color(0xFFE5E1E6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(slotIcon, size: 18, color: isAvailable ? Colors.white : Colors.black45),
                  const SizedBox(width: 6),
                  Text(
                    slot['id'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isAvailable ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _entryExitColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'ENTRY',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        SizedBox(height: 64),
        Icon(Icons.arrow_downward, size: 16, color: Colors.black54),
        SizedBox(height: 75),
        Icon(Icons.arrow_downward, size: 16, color: Colors.black54),
        SizedBox(height: 85),
        Text(
          'EXIT',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
      ],
    );
  }

  // ---------------- LEGEND ----------------
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _LegendItem(color: AppColors.teal, label: 'Available'),
        SizedBox(width: 20),
        _LegendItem(color: Color(0xFFE5E1E6), label: 'Occupied'),
      ],
    );
  }
}

// ---------------- LEGEND ITEM ----------------

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
