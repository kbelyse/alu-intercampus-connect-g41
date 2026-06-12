import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/providers/startup_provider.dart';
import '../../../shared/widgets/user_avatar.dart';

class GrowthDashboardScreen extends ConsumerWidget {
  const GrowthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final badges = ref.watch(badgesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Growth Dashboard', style: AppTypography.headlineMedium),
            Text('Your journey at ALU', style: AppTypography.bodySmall),
          ],
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1D2E), Color(0xFF242840)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  UserAvatar(
                    imageUrl: user.avatarUrl,
                    name: user.name,
                    size: 64,
                    borderColor: AppColors.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: AppTypography.headlineSmall),
                        Text(user.campus, style: AppTypography.bodySmall),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${user.participationStreak} day streak',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${user.leadershipPoints}',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('points', style: AppTypography.caption),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 28),

            // Stats grid
            Text('Your Stats', style: AppTypography.headlineSmall)
                .animate().fadeIn(delay: 50.ms),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatCard(
                  emoji: '🎉',
                  value: '${user.eventsAttended}',
                  label: 'Events Attended',
                  color: AppColors.primary,
                ),
                _StatCard(
                  emoji: '👥',
                  value: '${user.communitiesJoined}',
                  label: 'Communities',
                  color: AppColors.secondary,
                ),
                _StatCard(
                  emoji: '✅',
                  value: '${user.rsvpCount}',
                  label: 'Total RSVPs',
                  color: AppColors.success,
                ),
                _StatCard(
                  emoji: '🌐',
                  value: '${user.networkingScore}',
                  label: 'Networking Score',
                  color: AppColors.primary,
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 28),

            // Leadership progress
            Text('Leadership Progress', style: AppTypography.headlineSmall)
                .animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 14),
            _ProgressCard(
              title: 'Rising Leader',
              subtitle: 'Reach 500 points to unlock Gold status',
              progress: user.leadershipPoints / 500,
              current: user.leadershipPoints,
              target: 500,
              color: AppColors.primary,
            ).animate().fadeIn(delay: 180.ms),

            const SizedBox(height: 10),

            _ProgressCard(
              title: 'Community Connector',
              subtitle: 'Join 5 communities to earn this badge',
              progress: user.communitiesJoined / 5,
              current: user.communitiesJoined,
              target: 5,
              color: AppColors.secondary,
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 28),

            // Badges
            Row(
              children: [
                Text('Impact Badges', style: AppTypography.headlineSmall),
                const Spacer(),
                Text(
                  '${user.earnedBadgeIds.length}/${badges.length} earned',
                  style: AppTypography.caption.copyWith(color: AppColors.primary),
                ),
              ],
            ).animate().fadeIn(delay: 250.ms),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: badges.length,
              itemBuilder: (context, i) {
                final badge = badges[i];
                final isEarned = user.earnedBadgeIds.contains(badge.id);
                return _BadgeItem(badge: badge, isEarned: isEarned)
                    .animate(delay: Duration(milliseconds: 280 + i * 40))
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 300.ms,
                      curve: Curves.elasticOut,
                    );
              },
            ),

            const SizedBox(height: 28),

            // Interests
            Text('Your Interests', style: AppTypography.headlineSmall)
                .animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.interests.map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    interest,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 420.ms),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.headlineSmall.copyWith(color: color),
              ),
              Text(label,
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int current;
  final int target;
  final Color color;

  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppTypography.titleSmall)),
              Text(
                '$current / $target',
                style: AppTypography.caption.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTypography.caption),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clampedProgress,
              backgroundColor: AppColors.elevated,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final dynamic badge;
  final bool isEarned;

  const _BadgeItem({required this.badge, required this.isEarned});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isEarned
                ? AppColors.primaryLight
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEarned
                  ? AppColors.primary.withOpacity(0.4)
                  : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              badge.emoji as String,
              style: TextStyle(
                fontSize: 24,
                color: isEarned ? null : const Color(0x00000000),
              ),
            ),
          ),
          foregroundDecoration: isEarned
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.background.withOpacity(0.6),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          badge.name as String,
          style: AppTypography.caption.copyWith(
            fontSize: 9,
            color: isEarned ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
