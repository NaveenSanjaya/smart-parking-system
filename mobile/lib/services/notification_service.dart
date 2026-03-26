import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream user notifications
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({'isUnread': false});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Admin/System: Send notification
  Future<void> sendNotification(NotificationModel notification) async {
    try {
      await _firestore.collection('notifications').add(notification.toJson());
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }
}
