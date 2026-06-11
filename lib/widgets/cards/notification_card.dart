// Notification row card with type-coded icon, title, description, and timestamp.
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../../core/constants.dart';
import '../../models/notification_item.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.item, this.onTap});

  IconData get _icon {
    switch (item.type) {
      case NotificationType.event:
        return LucideIcons.calendar;
      case NotificationType.community:
        return LucideIcons.users;
      case NotificationType.mention:
        return LucideIcons.atSign;
    }
  }

  Color get _iconColor {
    switch (item.type) {
      case NotificationType.event:
        return AppColors.primary;
      case NotificationType.community:
        return AppColors.secondary;
      case NotificationType.mention:
        return AppColors.success;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: item.isRead
              ? AppColors.surface
              : AppColors.elevated,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: item.isRead ? AppColors.border : _iconColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(_icon, size: AppIconSize.inline, color: _iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: item.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              _formatTime(item.timestamp),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
