// Main home feed with greeting, campus filter, search, category chips, AI recommendations, and content sections.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/rsvp_provider.dart';
import '../../providers/community_provider.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/category_chip.dart';
import '../../widgets/common/gradient_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/avatar_circle.dart';
import '../../widgets/cards/event_card.dart';
import '../../widgets/cards/opportunity_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _filters = [
    (label: 'All', value: FeedFilter.all),
    (label: 'Events', value: FeedFilter.events),
    (label: 'Opportunities', value: FeedFilter.opportunities),
    (label: 'Clubs', value: FeedFilter.clubs),
    (label: 'Academic', value: FeedFilter.academic),
  ];

  static const _campuses = [
    (label: 'All Campuses', value: null),
    (label: 'Kigali', value: 'Kigali'),
    (label: 'Mauritius', value: 'Mauritius'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final feed = context.watch<FeedProvider>();
    final notif = context.watch<NotificationProvider>();
    final rsvp = context.watch<RsvpProvider>();
    final communities = context.watch<CommunityProvider>();

    final allRsvpedIds = {
      ...rsvp.getEventIdsByStatus(RsvpStatus.going),
      ...rsvp.getEventIdsByStatus(RsvpStatus.interested),
    };
    final recommended = feed.getRecommendations(
      rsvpedEventIds: allRsvpedIds,
      joinedCommunities: communities.joinedCommunities,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: () async =>
              await Future.delayed(const Duration(milliseconds: 600)),
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              // Top row
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${user?.name.split(' ').first ?? 'there'} 👋',
                            style:
                                Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            "What's happening at ALU today?",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/profile/notifications'),
                          child: AvatarCircle(
                            initials: user?.initials ?? 'AU',
                            size: 44,
                            imageUrl: user?.avatarUrl,
                          ),
                        ),
                        if (notif.unreadCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.background, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Campus filter bar
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  itemCount: _campuses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final c = _campuses[i];
                    final isSelected = feed.campusFilter == c.value;
                    return GestureDetector(
                      onTap: () => feed.setCampus(c.value),
                      child: AnimatedContainer(
                        duration: AppDuration.fast,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppRadius.chip),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (c.value != null) ...[
                              Text(
                                c.value == 'Kigali' ? '🇷🇼' : '🇲🇺',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              c.label,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
                child: AppSearchBar(
                  hintText: 'Search events, clubs, people...',
                  onChanged: feed.setSearch,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Filter chips
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final f = _filters[i];
                    return CategoryChip(
                      label: f.label,
                      isSelected: feed.activeFilter == f.value,
                      onTap: () => feed.setFilter(f.value),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Featured card
              if (feed.events.isNotEmpty)
                GradientCard(
                  event: feed.events.first,
                  onTap: () =>
                      context.push('/events/${feed.events.first.id}'),
                ),
              const SizedBox(height: AppSpacing.xxl),

              // AI Recommendations section
              if (recommended.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      const Text(
                        'For You',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFFC026D3)],
                          ),
                          borderRadius:
                              BorderRadius.circular(AppRadius.chip),
                        ),
                        child: const Text(
                          'AI Picks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: Text(
                    'Based on your communities and past events',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    itemCount: recommended.length,
                    itemBuilder: (context, i) => EventCard(
                      event: recommended[i],
                      isCompact: true,
                      onTap: () => context
                          .push('/events/${recommended[i].id}'),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // Opportunities section
              SectionHeader(
                title: 'Latest Opportunities',
                onSeeAll: () => context.push('/explore'),
              ),
              const SizedBox(height: AppSpacing.md),
              ...feed.opportunities.take(3).map(
                    (op) => OpportunityCard(opportunity: op),
                  ),
              const SizedBox(height: AppSpacing.xxl),

              // Events section
              SectionHeader(
                title: 'Upcoming Events',
                onSeeAll: () => context.push('/explore'),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  itemCount: feed.events.length,
                  itemBuilder: (context, i) => EventCard(
                    event: feed.events[i],
                    isCompact: true,
                    onTap: () =>
                        context.push('/events/${feed.events[i].id}'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
