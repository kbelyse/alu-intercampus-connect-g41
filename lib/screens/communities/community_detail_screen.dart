// Community detail with stats, posts/events/members tabs, and join/message button.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../data/mock_data.dart';
import '../../providers/community_provider.dart';
import '../../widgets/common/avatar_circle.dart';
import '../../widgets/common/shimmer_box.dart';
import '../../widgets/cards/event_card.dart';

class CommunityDetailScreen extends StatefulWidget {
  final String communityId;

  const CommunityDetailScreen({super.key, required this.communityId});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CommunityProvider>();
    final community = prov.getById(widget.communityId);
    if (community == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: const Center(
            child: Text('Community not found',
                style: TextStyle(color: AppColors.textSecondary))),
      );
    }

    final isJoined = prov.isJoined(community.id);
    final color = Color(int.parse('FF${community.colorHex}', radix: 16));
    final relatedEvents = mockEvents
        .where((e) => e.category == community.category)
        .take(3)
        .toList();

    const memberInitials = [
      'AU', 'KA', 'FD', 'AS', 'CO', 'MG', 'IT', 'NB', 'JO', 'LM',
      'SK', 'BT'
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(LucideIcons.arrowLeft,
                      color: AppColors.textPrimary),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(LucideIcons.moreVertical,
                        color: AppColors.textPrimary),
                    onPressed: () {},
                  ),
                ],
                title: Text(community.name,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Banner
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: community.bannerImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ShimmerBox(
                              width: double.infinity,
                              height: 200,
                              borderRadius: 0,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: color.withValues(alpha: 0.3),
                              child: Center(
                                child: Icon(LucideIcons.users,
                                    size: 64,
                                    color: Colors.white.withValues(alpha: 0.3)),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.background,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats row
                          Row(
                            children: [
                              _StatCol(
                                label: 'Members',
                                value: '${community.memberCount}',
                              ),
                              _divider(),
                              _StatCol(
                                  label: 'Events',
                                  value: '${relatedEvents.length}'),
                              _divider(),
                              _StatCol(label: 'Posts', value: '24'),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // About
                          Text('About',
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            community.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),

                    // Tabs
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.primary,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'Events'),
                        Tab(text: 'Members'),
                      ],
                    ),
                    const Divider(height: 1, color: AppColors.border),

                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _PostsTab(),
                          _EventsTab(events: relatedEvents),
                          _MembersTab(initials: memberInitials),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Sticky bottom button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg + MediaQuery.of(context).padding.bottom,
              ),
              color: AppColors.background,
              child: ElevatedButton(
                onPressed: () => prov.toggleJoin(community.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isJoined ? AppColors.secondary : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isJoined ? 'Message Group' : 'Join Community',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 40,
        width: 1,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        color: AppColors.border,
      );
}

class _StatCol extends StatelessWidget {
  final String label;
  final String value;

  const _StatCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PostsTab extends StatelessWidget {
  static const _posts = [
    ('🎉 Pitch night coming up!',
        'Don\'t miss our bi-monthly pitch competition this Friday.'),
    ('📢 New workshop added',
        'We\'re hosting a product design workshop on Jun 8.'),
    ('🏆 Congrats to Aline',
        'Our member Aline won 2nd place at the national hackathon!'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _posts.length,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.border),
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_posts[i].$1,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(_posts[i].$2,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _EventsTab extends StatelessWidget {
  final List events;

  const _EventsTab({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text('No events yet.',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: events.length,
      itemBuilder: (context, i) =>
          EventCard(event: events[i]),
    );
  }
}

class _MembersTab extends StatelessWidget {
  final List<String> initials;

  const _MembersTab({required this.initials});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: initials.length,
      itemBuilder: (context, i) => Column(
        children: [
          AvatarCircle(initials: initials[i], size: 48),
          const SizedBox(height: 4),
          Text(
            initials[i],
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
