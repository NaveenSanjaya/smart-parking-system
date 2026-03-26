import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { payment, parking, warning, info }

class NotificationModel {
  final String notificationId;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isUnread;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isUnread = true,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, String documentId) {
    NotificationType parsedType = NotificationType.info;
    if (json['notificationType'] != null) {
      try {
        parsedType = NotificationType.values.byName(json['notificationType'].toString().toLowerCase());
      } catch (e) {
        parsedType = NotificationType.info;
      }
    }

    return NotificationModel(
      notificationId: documentId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: parsedType,
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isUnread: json['isUnread'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'notificationType': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'isUnread': isUnread,
    };
  }
}
