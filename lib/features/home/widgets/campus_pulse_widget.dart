import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/providers/events_provider.dart';
import '../../../shared/providers/communities_provider.dart';

class CampusPulseWidget extends ConsumerWidget {
  const CampusPulseWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvents = ref.watch(allEventsProvider);
    final allCommunities = ref.watch(communitiesProvider);
    final totalAttendees = allEvents.fold(0, (sum, e) => sum + e.attendeeCount);
    final totalMembers = allCommunities.fold(0, (sum, c) => sum + c.memberCount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _PulseItem(
                value: '${allEvents.length}',
                label: 'Active Events',
                emoji: '🎉',
                color: AppColors.primary,
              ),
              _VerticalDivider(),
              _PulseItem(
                value: '${allCommunities.length}',
                label: 'Communities',
                emoji: '👥',
                color: AppColors.secondary,
              ),
              _VerticalDivider(),
              _PulseItem(
                value: '${(totalAttendees / 1000).toStringAsFixed(1)}k',
                label: 'Registrations',
                emoji: '✅',
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${totalMembers.toString()} students active across both campuses',
                style: AppTypography.caption,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Kigali + Mauritius',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PulseItem extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  final Color color;

  const _PulseItem({
    required this.value,
    required this.label,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      color: AppColors.border,
    );
  }
}
