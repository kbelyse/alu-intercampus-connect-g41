// Manages notifications list and unread count.
import 'package:flutter/foundation.dart';
import '../models/notification_item.dart';
import '../data/mock_data.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationItem> _items = List.from(mockNotifications);
  NotificationType? _activeFilter;

  List<NotificationItem> get all => _items;

  int get unreadCount =>
      _items.where((n) => !n.isRead).length;

  NotificationType? get activeFilter => _activeFilter;

  List<NotificationItem> get filtered {
    if (_activeFilter == null) return _items;
    return _items.where((n) => n.type == _activeFilter).toList();
  }

  void setFilter(NotificationType? type) {
    _activeFilter = type;
    notifyListeners();
  }

  void markRead(String id) {
    final idx = _items.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    _items[idx] = _items[idx].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllRead() {
    for (int i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isRead: true);
    }
    notifyListeners();
  }
}
