// Community list card with colored initial circle, member count, and join button.
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../models/community.dart';
import '../common/shimmer_box.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final bool isJoined;
  final VoidCallback onJoinToggle;
  final VoidCallback? onTap;

  const CommunityCard({
    super.key,
    required this.community,
    required this.isJoined,
    required this.onJoinToggle,
    this.onTap,
  });

  Color get _color {
    final hex = community.colorHex;
    return Color(int.parse('FF$hex', radix: 16));
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: community.bannerImageUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ShimmerBox(width: 44, height: 44, borderRadius: 22),
                errorWidget: (context, url, error) => Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    community.name.substring(0, 1),
                    style: TextStyle(
                      color: _color,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          community.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (community.isActiveNow)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${community.memberCount} members · ${community.lastActivity}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: onJoinToggle,
              child: AnimatedContainer(
                duration: AppDuration.fast,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 6),
                decoration: BoxDecoration(
                  color: isJoined
                      ? AppColors.success.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  border: Border.all(
                    color:
                        isJoined ? AppColors.success : AppColors.primary,
                  ),
                ),
                child: Text(
                  isJoined ? 'Joined' : 'Join',
                  style: TextStyle(
                    color:
                        isJoined ? AppColors.success : AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
