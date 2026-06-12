import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/models/event_model.dart';
import '../../shared/providers/user_provider.dart';
import 'user_avatar.dart';

class EventCard extends ConsumerWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final bool compact;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isRsvped = user.rsvpedEventIds.contains(event.id);
    final isSaved = user.savedEventIds.contains(event.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
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
                  imageUrl: event.imageUrl,
                  height: compact ? 120 : 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: compact ? 120 : 160,
                    color: AppColors.elevated,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: compact ? 120 : 160,
                    color: AppColors.elevated,
                    child: const Icon(Icons.image_outlined, color: AppColors.textSecondary),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _TypeBadge(event.typeLabel),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _SaveButton(isSaved: isSaved, onTap: () {
                    if (isSaved) {
                      ref.read(userProvider.notifier).unsaveEvent(event.id);
                    } else {
                      ref.read(userProvider.notifier).saveEvent(event.id);
                    }
                  }),
                ),
                if (isRsvped)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'RSVP\'d',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.title,
                    style: AppTypography.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat('MMM d, yyyy · h:mm a').format(event.date),
                        style: AppTypography.caption.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTypography.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        AvatarStack(
                          avatarUrls: event.participantAvatars,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${event.attendeeCount} attending',
                          style: AppTypography.caption,
                        ),
                        const Spacer(),
                        Text(
                          event.campus,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  const _TypeBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;
  const _SaveButton({required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
          color: isSaved ? AppColors.primary : AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

// Horizontal compact card for featured row
class EventCardHorizontal extends ConsumerWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCardHorizontal({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
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
                  imageUrl: event.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 130, color: AppColors.elevated),
                  errorWidget: (_, __, ___) =>
                      Container(height: 130, color: AppColors.elevated),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _TypeBadge(event.typeLabel),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.title,
                    style: AppTypography.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 11, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d').format(event.date),
                        style: AppTypography.caption.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.people_outline,
                          size: 11, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${event.attendeeCount}',
                        style: AppTypography.caption,
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
