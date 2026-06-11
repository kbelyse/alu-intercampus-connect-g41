// Chat list row with avatar, last message snippet, timestamp, and unread badge.
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/chat_room.dart';
import '../common/avatar_circle.dart';
import 'package:intl/intl.dart';

class ChatPreviewCard extends StatelessWidget {
  final ChatRoom room;
  final VoidCallback? onTap;

  const ChatPreviewCard({super.key, required this.room, this.onTap});

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (now.difference(dt).inHours < 24) {
      return DateFormat('h:mm a').format(dt);
    }
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = room.unreadCount > 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        color: hasUnread
            ? AppColors.surface.withValues(alpha: 0.8)
            : Colors.transparent,
        child: Row(
          children: [
            AvatarCircle(
              initials: room.name.substring(0, 2).toUpperCase(),
              size: 48,
              color: Color(int.parse('FF${room.colorHex}', radix: 16)),
              imageUrl: room.avatarUrl,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: hasUnread
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    room.lastMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: hasUnread
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(room.lastMessageTime),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${room.unreadCount}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
