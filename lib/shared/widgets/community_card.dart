import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/models/community_model.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/providers/communities_provider.dart';
import 'user_avatar.dart';

class CommunityCard extends ConsumerWidget {
  final CommunityModel community;
  final VoidCallback? onTap;
  final bool compact;

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isJoined = user.joinedCommunityIds.contains(community.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: community.coverUrl,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 90, color: AppColors.elevated),
                  errorWidget: (_, __, ___) =>
                      Container(height: 90, color: AppColors.elevated),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                  ),
                ),
                if (community.isTrending)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department,
                              size: 10, color: AppColors.background),
                          const SizedBox(width: 3),
                          Text(
                            'Trending',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.background,
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          community.name,
                          style: AppTypography.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    community.description,
                    style: AppTypography.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AvatarStack(
                        avatarUrls: community.memberAvatars,
                        size: 22,
                        maxVisible: 3,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${community.memberCount} members',
                        style: AppTypography.caption,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (isJoined) {
                            ref.read(communitiesProvider.notifier).leaveCommunity(community.id);
                          } else {
                            ref.read(communitiesProvider.notifier).joinCommunity(community.id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: isJoined ? AppColors.elevated : AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                            border: isJoined
                                ? Border.all(color: AppColors.border)
                                : null,
                          ),
                          child: Text(
                            isJoined ? 'Joined' : 'Join',
                            style: AppTypography.labelSmall.copyWith(
                              color: isJoined ? AppColors.textSecondary : AppColors.background,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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
}

class CommunityCardCompact extends ConsumerWidget {
  final CommunityModel community;
  final VoidCallback? onTap;

  const CommunityCardCompact({
    super.key,
    required this.community,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isJoined = user.joinedCommunityIds.contains(community.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: community.imageUrl,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(width: 36, height: 36, color: AppColors.elevated),
                    errorWidget: (_, __, ___) =>
                        Container(width: 36, height: 36, color: AppColors.elevated),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    community.name,
                    style: AppTypography.titleSmall.copyWith(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${community.memberCount} members',
              style: AppTypography.caption,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: isJoined ? AppColors.elevated : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
                border: isJoined ? Border.all(color: AppColors.border) : null,
              ),
              child: Text(
                isJoined ? 'Joined' : 'Join',
                style: AppTypography.labelSmall.copyWith(
                  color: isJoined ? AppColors.textSecondary : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
