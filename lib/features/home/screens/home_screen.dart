import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/providers/events_provider.dart';
import '../../../shared/providers/communities_provider.dart';
import '../../../shared/providers/notifications_provider.dart';
import '../../../shared/providers/recommendations_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/community_card.dart';
import '../../../shared/widgets/recommendation_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../widgets/campus_pulse_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final recommended = ref.watch(recommendedEventsProvider);
    final featured = ref.watch(featuredEventsProvider);
    final trending = ref.watch(trendingCommunitiesProvider);
    final upcoming = ref.watch(upcomingEventsProvider);
    final unreadCount = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            expandedHeight: 0,
            floating: true,
            snap: true,
            elevation: 0,
            flexibleSpace: Container(color: AppColors.background),
            titleSpacing: AppConstants.paddingLG,
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Good morning 👋',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        user.name.split(' ').first,
                        style: AppTypography.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => context.push('/notifications'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 9 ? '9+' : '$unreadCount',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => context.go('/profile'),
                  child: UserAvatar(
                    imageUrl: user.avatarUrl,
                    name: user.name,
                    size: 40,
                    borderColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingLG, 12,
                  AppConstants.paddingLG, 0),
              child: AppSearchBar(
                readOnly: true,
                onTap: () => context.push('/search'),
              ),
            ),
          ),

          // Recommended For You
          if (recommended.isNotEmpty)
            SliverToBoxAdapter(
              child: _Section(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SectionHeader(
                      title: 'Recommended For You',
                      subtitle: 'Personalized based on your interests',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome,
                                size: 11, color: AppColors.secondary),
                            const SizedBox(width: 4),
                            Text(
                              'AI Powered',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 248,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: recommended.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => RecommendationCard(
                          event: recommended[i],
                          index: i,
                          onTap: () =>
                              context.push('/opportunity/${recommended[i].id}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),

          // Campus Pulse
          SliverToBoxAdapter(
            child: _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SectionHeader(
                    title: 'Campus Pulse',
                    subtitle: 'What\'s happening right now',
                  ),
                  const SizedBox(height: 16),
                  const CampusPulseWidget(),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          ),

          // Featured Opportunities
          if (featured.isNotEmpty)
            SliverToBoxAdapter(
              child: _Section(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SectionHeader(
                      title: 'Featured',
                      subtitle: 'Hand-picked for you',
                      actionLabel: 'See all',
                      onAction: () => context.push('/my-events'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 232,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: featured.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => EventCardHorizontal(
                          event: featured[i],
                          onTap: () =>
                              context.push('/opportunity/${featured[i].id}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
            ),

          // Trending Communities
          if (trending.isNotEmpty)
            SliverToBoxAdapter(
              child: _Section(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SectionHeader(
                      title: 'Trending Communities',
                      actionLabel: 'Explore',
                      onAction: () => context.go('/communities'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: trending.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => CommunityCardCompact(
                          community: trending[i],
                          onTap: () =>
                              context.push('/community/${trending[i].id}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            ),

          // Startup Spotlight
          SliverToBoxAdapter(
            child: _Section(
              child: _StartupSpotlightBanner(
                onTap: () => context.push('/startup'),
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
          ),

          // Upcoming Events
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingLG, 0,
                  AppConstants.paddingLG, 0),
              child: SectionHeader(
                title: 'Upcoming Events',
                actionLabel: 'View all',
                onAction: () => context.push('/my-events'),
              ),
            ).animate().fadeIn(delay: 300.ms),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingLG, 16,
                AppConstants.paddingLG, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: EventCard(
                    event: upcoming[i],
                    onTap: () => context.push('/opportunity/${upcoming[i].id}'),
                  ).animate(delay: Duration(milliseconds: 300 + i * 80))
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.15, duration: 400.ms, curve: Curves.easeOut),
                ),
                childCount: upcoming.take(4).length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final Widget child;
  const _Section({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppConstants.paddingLG, AppConstants.paddingLG,
          AppConstants.paddingLG, 0),
      child: child,
    );
  }
}

class _StartupSpotlightBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _StartupSpotlightBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1D2E), Color(0xFF242840)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('💡', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Startup Corner',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '4 startups looking for co-founders & collaborators',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
