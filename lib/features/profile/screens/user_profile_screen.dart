import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/providers/startup_provider.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/primary_button.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final badges = ref.watch(badgesProvider);
    final earnedBadges =
        badges.where((b) => user.earnedBadgeIds.contains(b.id)).toList();

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
            title: Text('Profile', style: AppTypography.headlineMedium),
            actions: [
              GestureDetector(
                onTap: () => context.push('/settings'),
                child: Padding(
                  padding: const EdgeInsets.only(right: AppConstants.paddingLG),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.settings_outlined,
                        color: AppColors.textPrimary, size: 18),
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAvatar(
                        imageUrl: user.avatarUrl,
                        name: user.name,
                        size: 80,
                        borderColor: AppColors.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: AppTypography.headlineMedium),
                            const SizedBox(height: 4),
                            Text(user.major, style: AppTypography.bodySmall),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  '${user.campus} Campus',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 16),

                  Text(user.bio,
                          style: AppTypography.bodyMedium.copyWith(height: 1.6))
                      .animate()
                      .fadeIn(delay: 50.ms),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Edit Profile',
                          onPressed: () => context.push('/edit-profile'),
                          backgroundColor: AppColors.elevated,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => context.push('/dashboard'),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.bar_chart_rounded,
                              color: AppColors.primary, size: 22),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 24),

                  // Stats strip
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        _StatItem(
                            value: '${user.eventsAttended}',
                            label: 'Events'),
                        _StatDivider(),
                        _StatItem(
                            value: '${user.communitiesJoined}',
                            label: 'Communities'),
                        _StatDivider(),
                        _StatItem(
                            value: '${user.leadershipPoints}',
                            label: 'Points'),
                        _StatDivider(),
                        _StatItem(
                            value: '${user.networkingScore}',
                            label: 'Network'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 24),

                  // Quick links
                  _QuickLinks(
                    onMyEvents: () => context.push('/my-events'),
                    onMyCommunities: () => context.push('/my-communities'),
                    onSaved: () => context.push('/saved'),
                    onDashboard: () => context.push('/dashboard'),
                    onStartup: () => context.push('/startup'),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 24),

                  // Badges
                  if (earnedBadges.isNotEmpty) ...[
                    Text('My Badges', style: AppTypography.headlineSmall)
                        .animate().fadeIn(delay: 250.ms),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: earnedBadges.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final badge = earnedBadges[i];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(badge.emoji,
                                      style:
                                          const TextStyle(fontSize: 24)),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 56,
                                child: Text(
                                  badge.name,
                                  style:
                                      AppTypography.caption.copyWith(fontSize: 9),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ).animate(
                              delay: Duration(milliseconds: 280 + i * 60))
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                            );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Interests
                  Text('Interests', style: AppTypography.headlineSmall)
                      .animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 320.ms),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: AppTypography.headlineSmall
                  .copyWith(color: AppColors.primary)),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.border);
  }
}

class _QuickLinks extends StatelessWidget {
  final VoidCallback onMyEvents;
  final VoidCallback onMyCommunities;
  final VoidCallback onSaved;
  final VoidCallback onDashboard;
  final VoidCallback onStartup;

  const _QuickLinks({
    required this.onMyEvents,
    required this.onMyCommunities,
    required this.onSaved,
    required this.onDashboard,
    required this.onStartup,
  });

  @override
  Widget build(BuildContext context) {
    final links = [
      _Link('🎉', 'My Events', onMyEvents),
      _Link('👥', 'Communities', onMyCommunities),
      _Link('🔖', 'Saved', onSaved),
      _Link('📊', 'Dashboard', onDashboard),
      _Link('💡', 'Startup Corner', onStartup),
    ];

    return Column(
      children: links.map((link) {
        return GestureDetector(
          onTap: link.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Text(link.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(link.label, style: AppTypography.titleSmall),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Link {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  _Link(this.emoji, this.label, this.onTap);
}
