enum NotificationType { event, community, opportunity, message, badge, system }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? actionId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.actionId,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      type: type,
      actionId: actionId,
    );
  }

  String get typeIcon {
    switch (type) {
      case NotificationType.event:
        return '🎉';
      case NotificationType.community:
        return '👥';
      case NotificationType.opportunity:
        return '💼';
      case NotificationType.message:
        return '💬';
      case NotificationType.badge:
        return '🏆';
      case NotificationType.system:
        return '🔔';
    }
  }
}
