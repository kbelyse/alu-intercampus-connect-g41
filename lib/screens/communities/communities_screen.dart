// Communities screen with Discover/My Clubs tabs, trending section, and search.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/community_provider.dart';
import '../../models/community.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/cards/community_card.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CommunityProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Text(
                'Communities',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppSearchBar(
                hintText: 'Search communities...',
                onChanged: prov.setSearch,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 14),
              tabs: const [Tab(text: 'Discover'), Tab(text: 'My Clubs')],
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _DiscoverTab(prov: prov),
                  _MyClubsTab(prov: prov),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  final CommunityProvider prov;

  const _DiscoverTab({required this.prov});

  @override
  Widget build(BuildContext context) {
    final trending =
        prov.allCommunities.where((c) => c.isActiveNow).toList();
    final all = prov.allCommunities;

    if (all.isEmpty) {
      return const EmptyState(
          message: 'No communities found.', icon: LucideIcons.users);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        if (trending.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: Text('Trending',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: trending.length,
              itemBuilder: (context, i) =>
                  _TrendingCard(community: trending[i]),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.border, indent: 16, endIndent: 16),
          const SizedBox(height: AppSpacing.sm),
        ],
        ...all.map(
          (c) => CommunityCard(
            community: c,
            isJoined: prov.isJoined(c.id),
            onJoinToggle: () => prov.toggleJoin(c.id),
            onTap: () => context.push('/communities/${c.id}'),
          ),
        ),
      ],
    );
  }
}

class _MyClubsTab extends StatelessWidget {
  final CommunityProvider prov;

  const _MyClubsTab({required this.prov});

  @override
  Widget build(BuildContext context) {
    final joined = prov.joinedCommunities;
    if (joined.isEmpty) {
      return const EmptyState(
        message: 'You haven\'t joined any communities yet.',
        icon: LucideIcons.users,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: joined.length,
      itemBuilder: (context, i) => CommunityCard(
        community: joined[i],
        isJoined: true,
        onJoinToggle: () => prov.toggleJoin(joined[i].id),
        onTap: () => context.push('/communities/${joined[i].id}'),
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final Community community;

  const _TrendingCard({required this.community});

  @override
  Widget build(BuildContext context) {
    final color = Color(
        int.parse('FF${community.colorHex}', radix: 16));
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              const SizedBox(width: 4),
              const Text(
                'Active',
                style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Spacer(),
          Text(
            community.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            '${community.memberCount} members',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
