import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/chat_provider.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(chatRoomsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            snap: true,
            elevation: 0,
            titleSpacing: AppConstants.paddingLG,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Messages', style: AppTypography.headlineMedium),
                Text('${rooms.where((r) => r.unreadCount > 0).length} unread',
                    style: AppTypography.bodySmall),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppConstants.paddingLG),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      color: AppColors.textPrimary, size: 18),
                ),
              ),
            ],
          ),

          if (rooms.isEmpty)
            const SliverFillRemaining(
              child: EmptyStateWidget(
                emoji: '💬',
                title: 'No messages yet',
                subtitle: 'Join communities and start connecting with fellow students',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final room = rooms[i];
                    return _ChatRoomTile(
                      room: room,
                      onTap: () {
                        ref.read(chatRoomsProvider.notifier).markAsRead(room.id);
                        context.push('/chat/${room.id}');
                      },
                    ).animate(delay: Duration(milliseconds: i * 50))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: -0.05, duration: 300.ms, curve: Curves.easeOut);
                  },
                  childCount: rooms.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final dynamic room;
  final VoidCallback onTap;

  const _ChatRoomTile({required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeStr = _formatTime(room.lastMessageTime);
    final hasUnread = room.unreadCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLG, vertical: 14),
        color: hasUnread
            ? AppColors.surface.withOpacity(0.5)
            : Colors.transparent,
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                UserAvatar(
                  imageUrl: room.avatarUrl,
                  name: room.name,
                  size: 52,
                  showOnlineIndicator: !room.isGroup,
                  isOnline: room.isOnline,
                ),
                if (room.isGroup)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                      child: const Icon(Icons.people,
                          size: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight:
                                hasUnread ? FontWeight.w700 : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeStr,
                        style: AppTypography.caption.copyWith(
                          color: hasUnread
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.lastMessage,
                          style: AppTypography.bodySmall.copyWith(
                            color: hasUnread
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            room.unreadCount > 9 ? '9+' : '${room.unreadCount}',
                            style: const TextStyle(
                              color: AppColors.background,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(t);
  }
}
