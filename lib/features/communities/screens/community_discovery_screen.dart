import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/communities_provider.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/community_card.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class CommunityDiscoveryScreen extends ConsumerStatefulWidget {
  const CommunityDiscoveryScreen({super.key});

  @override
  ConsumerState<CommunityDiscoveryScreen> createState() =>
      _CommunityDiscoveryScreenState();
}

class _CommunityDiscoveryScreenState
    extends ConsumerState<CommunityDiscoveryScreen> {
  String _query = '';
  String _filter = 'All';

  static const List<String> _filters = [
    'All', 'Trending', 'Joined', 'Technology', 'Business', 'Impact'
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final allCommunities = ref.watch(communitiesProvider);

    var filtered = allCommunities.where((c) {
      final matchQuery = _query.isEmpty ||
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.description.toLowerCase().contains(_query.toLowerCase());
      final matchFilter = switch (_filter) {
        'Trending' => c.isTrending,
        'Joined' => user.joinedCommunityIds.contains(c.id),
        'Technology' => c.tags.contains('Technology'),
        'Business' => c.tags.any((t) =>
            t.contains('Entrepreneurship') || t.contains('Finance')),
        'Impact' => c.tags.contains('Social Impact'),
        _ => true,
      };
      return matchQuery && matchFilter;
    }).toList();

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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Communities', style: AppTypography.headlineMedium),
                Text('Find your people', style: AppTypography.bodySmall),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppConstants.paddingLG),
                child: GestureDetector(
                  onTap: () => context.push('/my-communities'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      'My Communities',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingLG, 8,
                  AppConstants.paddingLG, 0),
              child: AppSearchBar(
                hintText: 'Search communities...',
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingLG, 12, AppConstants.paddingLG, 12),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final isActive = f == _filter;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        f,
                        style: AppTypography.labelSmall.copyWith(
                          color: isActive
                              ? AppColors.background
                              : AppColors.textSecondary,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          if (filtered.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                emoji: '🔍',
                title: 'No communities found',
                subtitle: 'Try a different search or filter',
                actionLabel: 'Clear filters',
                onAction: () => setState(() {
                  _query = '';
                  _filter = 'All';
                }),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingLG, 8,
                  AppConstants.paddingLG, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.4,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => CommunityCard(
                    community: filtered[i],
                    onTap: () => context.push('/community/${filtered[i].id}'),
                  ).animate(delay: Duration(milliseconds: i * 60))
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
