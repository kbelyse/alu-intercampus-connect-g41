// Explore screen with tab filters, recommended cards, and mixed content list.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/feed_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/cards/event_card.dart';
import '../../widgets/cards/opportunity_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  static const _tabs = ['All', 'Events', 'Opportunities', 'Clubs'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<FeedProvider>();
    final notif = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(
                children: [
                  Text(
                    'Explore',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.push('/profile/notifications'),
                        child: const Icon(
                          LucideIcons.bell,
                          color: AppColors.textPrimary,
                          size: AppIconSize.standalone,
                        ),
                      ),
                      if (notif.unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg),
              child: AppSearchBar(
                controller: _searchController,
                hintText: 'Search everything...',
                onChanged: feed.setSearch,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Tab bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 14),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg),
              tabAlignment: TabAlignment.start,
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _AllTab(feed: feed),
                  _EventsTab(feed: feed),
                  _OpportunitiesTab(feed: feed),
                  _ClubsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllTab extends StatelessWidget {
  final FeedProvider feed;

  const _AllTab({required this.feed});

  @override
  Widget build(BuildContext context) {
    if (feed.events.isEmpty && feed.opportunities.isEmpty) {
      return const EmptyState(
        message: 'Nothing here yet. Check back soon.',
        icon: LucideIcons.compass,
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        if (feed.events.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
            child: Text(
              'Recommended for you',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg),
              itemCount: feed.events.take(4).length,
              itemBuilder: (context, i) => EventCard(
                event: feed.events[i],
                isCompact: true,
                onTap: () =>
                    context.push('/events/${feed.events[i].id}'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        ...feed.events.map(
          (e) => EventCard(
              event: e,
              onTap: () => context.push('/events/${e.id}')),
        ),
        ...feed.opportunities.map(
          (op) => OpportunityCard(opportunity: op),
        ),
      ],
    );
  }
}

class _EventsTab extends StatelessWidget {
  final FeedProvider feed;

  const _EventsTab({required this.feed});

  @override
  Widget build(BuildContext context) {
    if (feed.events.isEmpty) {
      return const EmptyState(
          message: 'No events found.', icon: LucideIcons.calendar);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: feed.events.length,
      itemBuilder: (context, i) => EventCard(
        event: feed.events[i],
        onTap: () => context.push('/events/${feed.events[i].id}'),
      ),
    );
  }
}

class _OpportunitiesTab extends StatelessWidget {
  final FeedProvider feed;

  const _OpportunitiesTab({required this.feed});

  @override
  Widget build(BuildContext context) {
    if (feed.opportunities.isEmpty) {
      return const EmptyState(
          message: 'No opportunities found.', icon: LucideIcons.briefcase);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: feed.opportunities.length,
      itemBuilder: (context, i) =>
          OpportunityCard(opportunity: feed.opportunities[i]),
    );
  }
}

class _ClubsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: const EmptyState(
        message: 'Browse clubs from the Communities tab.',
        icon: LucideIcons.users,
      ),
    );
  }
}
