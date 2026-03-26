import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/models/notification_model.dart';
import 'package:mobile/screens/global_screens/notification_state.dart' show unreadCountNotifier;
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/services/auth_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  final AuthService _authService = AuthService();
  List<NotificationModel> _currentNotifications = [];

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays} d ago';
    if (diff.inHours > 0) return '${diff.inHours} hr ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} m ago';
    return 'Just now';
  }

  void _markAllRead() async {
    for (var notification in _currentNotifications) {
      if (notification.isUnread) {
        await _notificationService.markAsRead(notification.notificationId);
      }
    }
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
              child: _authService.currentUser == null
                ? const Center(child: Text('Not logged in'))
                : StreamBuilder<List<NotificationModel>>(
                    stream: _notificationService.getUserNotifications(_authService.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No notifications yet.'));
                      }
                      
                      _currentNotifications = snapshot.data!;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        unreadCountNotifier.value = _currentNotifications.where((n) => n.isUnread).length;
                      });

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _currentNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = _currentNotifications[index];
                          return Dismissible(
                            key: ValueKey(notification.notificationId),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade600,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.mark_email_read, color: Colors.white),
                            ),
                            onDismissed: (_) {
                               _notificationService.markAsRead(notification.notificationId);
                            },
                            child: _notificationCard(notification),
                          );
                        },
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
              ValueListenableBuilder<int>(
                valueListenable: unreadCountNotifier,
                builder: (context, val, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      '$val new',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                }
              ),
        ],
      ),
    );
  }

  // ---------------- NOTIFICATION CARD ----------------
  Widget _notificationCard(NotificationModel notification) {
    IconData icon = Icons.info;
    Color iconColor = AppColors.teal;
    Color iconBg = AppColors.teal.withValues(alpha: 0.15);

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
                  _formatTime(notification.timestamp),
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
