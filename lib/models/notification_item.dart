// NotificationItem model for in-app notifications.
enum NotificationType { event, community, mention }

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        id: id,
        title: title,
        description: description,
        timestamp: timestamp,
        type: type,
        isRead: isRead ?? this.isRead,
      );
}
