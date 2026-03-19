import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/models/notification_model.dart';
import 'package:mobile/screens/global_screens/notification_state.dart' show unreadCountNotifier;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'Payment Successful',
      message: 'Your parking fee of \$9.00 has been processed successfully.',
      time: '2 mins ago',
      type: NotificationType.payment,
    ),
    NotificationItem(
      id: '2',
      title: 'Parking Session Started',
      message: 'Your parking session has begun at Level 2, Slot B-24.',
      time: '2 hours ago',
      type: NotificationType.parking,
    ),
    NotificationItem(
      id: '3',
      title: 'New Rate Update',
      message: 'Parking rates have been updated. Check the new pricing structure.',
      time: '1 day ago',
      type: NotificationType.info,
    ),
    NotificationItem(
      id: '4',
      title: 'Parking Almost Full',
      message: 'Only 12 slots remaining on Level 4. Consider alternative levels.',
      time: '2 days ago',
      type: NotificationType.warning,
    ),
  ];

  // add more notifications here...

  int get unreadCount => notifications.where((n) => n.isUnread).length;

  void _removeNotification(String id) {
    setState(() {
      final removedIndex = notifications.indexWhere((n) => n.id == id);
      if (removedIndex != -1) {
        // If the removed notification was unread, decrement the global unread counter.
        if (notifications[removedIndex].isUnread) {
          unreadCountNotifier.value = (unreadCountNotifier.value - 1).clamp(0, 999);
        }
        notifications.removeAt(removedIndex);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unreadCountNotifier.value = unreadCount;
    });
  }

  void _markAllRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isUnread = false;
      }
      unreadCountNotifier.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Dismissible(
                    key: ValueKey(notification.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _removeNotification(notification.id),
                    child: _notificationCard(notification),
                  );
                },
              ),
            ),
            _markAllReadButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Stay updated with your parking activities',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: Text(
              '$unreadCount new',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- NOTIFICATION CARD ----------------
  Widget _notificationCard(NotificationItem notification) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    // Determine icon and color based on type
    switch (notification.type) {
      case NotificationType.payment:
        icon = Icons.check_circle;
        iconColor = Colors.green;
        iconBg = const Color(0xFFDFF5E7);
        break;
      case NotificationType.parking:
        icon = Icons.directions_car;
        iconColor = AppColors.teal;
        iconBg = AppColors.teal.withValues(alpha: 0.15);
        break;
      case NotificationType.warning:
        icon = Icons.warning;
        iconColor = Colors.orange;
        iconBg = Colors.orange.withValues(alpha: 0.15);
        break;
      case NotificationType.info:
        icon = Icons.info;
        iconColor = AppColors.teal;
        iconBg = AppColors.teal.withValues(alpha: 0.15);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isUnread ? const Color(0xFFF3FBF6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(notification.message, style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 6),
                Text(
                  notification.time,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          if (notification.isUnread) const Icon(Icons.circle, size: 8, color: Colors.black54),
        ],
      ),
    );
  }

  // ---------------- FOOTER BUTTON ----------------
  Widget _markAllReadButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: _markAllRead,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text('Mark All as Read'),
        ),
      ),
    );
  }
}
