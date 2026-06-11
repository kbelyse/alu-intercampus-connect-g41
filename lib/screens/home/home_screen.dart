// Main home feed with greeting, search, filter chips, featured card, and content sections.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/notification_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final user =
        context.watch<AuthProvider>().user;
    final feed = context.watch<FeedProvider>();
    final notif = context.watch<NotificationProvider>();

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

              // Opportunities section
              SectionHeader(
                title: 'Latest Opportunities',
                onSeeAll: () {},
              ),
              const SizedBox(height: AppSpacing.md),
              ...feed.opportunities.take(3).map(
                    (op) => OpportunityCard(opportunity: op),
                  ),
              const SizedBox(height: AppSpacing.xxl),

              // Events section
              SectionHeader(
                title: 'Upcoming Events',
                onSeeAll: () {},
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
