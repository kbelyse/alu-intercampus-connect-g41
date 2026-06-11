// Chats list with active now row, chat previews, and swipe-to-archive.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/avatar_circle.dart';
import '../../widgets/cards/chat_preview_card.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(
                children: [
                  Text(
                    'Chats',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.pencil,
                        color: AppColors.textPrimary, size: AppIconSize.standalone),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: const AppSearchBar(hintText: 'Search conversations...'),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Active Now
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg),
              child: Text(
                'Active Now',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: chat.rooms
                    .where((r) => r.isActiveNow)
                    .length,
                itemBuilder: (context, i) {
                  final activeRooms =
                      chat.rooms.where((r) => r.isActiveNow).toList();
                  final room = activeRooms[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: GestureDetector(
                      onTap: () => context.push('/chats/${room.id}'),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AvatarCircle(
                            initials: room.name
                                .substring(0, 2)
                                .toUpperCase(),
                            size: 52,
                            color: Color(int.parse(
                                'FF${room.colorHex}',
                                radix: 16)),
                            imageUrl: room.avatarUrl,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.background, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1, color: AppColors.border),

            // Chat list with swipe to archive/mute
            Expanded(
              child: ListView.separated(
                itemCount: chat.rooms.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (context, i) {
                  final room = chat.rooms[i];
                  return Dismissible(
                    key: ValueKey(room.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding:
                          const EdgeInsets.only(right: AppSpacing.xl),
                      color: AppColors.neutralTag,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(LucideIcons.archive,
                              color: AppColors.textSecondary, size: 20),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            'Archive',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Icon(LucideIcons.volumeX,
                              color: AppColors.textSecondary, size: 20),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            'Mute',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async => false,
                    child: ChatPreviewCard(
                      room: room,
                      onTap: () => context.push('/chats/${room.id}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
