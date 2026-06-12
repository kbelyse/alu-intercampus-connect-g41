import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/events_provider.dart';
import '../../../shared/providers/communities_provider.dart';
import '../../../shared/providers/opportunities_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/community_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/opportunity_card.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allEvents = ref.watch(allEventsProvider);
    final allCommunities = ref.watch(communitiesProvider);
    final allOpportunities = ref.watch(allOpportunitiesProvider);

    final filteredEvents = _query.isEmpty
        ? <dynamic>[]
        : allEvents
            .where((e) =>
                e.title.toLowerCase().contains(_query.toLowerCase()) ||
                e.categories.any(
                    (c) => c.toLowerCase().contains(_query.toLowerCase())))
            .toList();

    final filteredCommunities = _query.isEmpty
        ? <dynamic>[]
        : allCommunities
            .where((c) =>
                c.name.toLowerCase().contains(_query.toLowerCase()) ||
                c.tags.any(
                    (t) => t.toLowerCase().contains(_query.toLowerCase())))
            .toList();

    final filteredOpps = _query.isEmpty
        ? <dynamic>[]
        : allOpportunities
            .where((o) =>
                o.title.toLowerCase().contains(_query.toLowerCase()) ||
                o.company.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    final totalResults =
        filteredEvents.length + filteredCommunities.length + filteredOpps.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: AppTypography.titleSmall,
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
            hintText: 'Search events, communities...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.textSecondary),
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? _SearchSuggestions()
          : totalResults == 0
              ? EmptyStateWidget(
                  emoji: '🔍',
                  title: 'No results for "$_query"',
                  subtitle: 'Try different keywords or browse categories',
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingLG),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalResults results for "$_query"',
                        style: AppTypography.bodySmall,
                      ).animate().fadeIn(duration: 200.ms),

                      if (filteredEvents.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text('Events', style: AppTypography.headlineSmall),
                        const SizedBox(height: 12),
                        ...filteredEvents.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: EventCard(
                                event: e,
                                onTap: () =>
                                    context.push('/opportunity/${e.id}'),
                              ).animate().fadeIn(duration: 300.ms),
                            )),
                      ],

                      if (filteredCommunities.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text('Communities', style: AppTypography.headlineSmall),
                        const SizedBox(height: 12),
                        ...filteredCommunities.map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CommunityCard(
                                community: c,
                                onTap: () =>
                                    context.push('/community/${c.id}'),
                              ).animate().fadeIn(duration: 300.ms),
                            )),
                      ],

                      if (filteredOpps.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text('Opportunities', style: AppTypography.headlineSmall),
                        const SizedBox(height: 12),
                        ...filteredOpps.map((o) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: OpportunityCard(opportunity: o)
                                  .animate()
                                  .fadeIn(duration: 300.ms),
                            )),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'AI Summit',
      'Hackathon',
      'Entrepreneurship',
      'Product Design',
      'Leadership',
      'Women in Tech',
      'Internship',
      'Fellowship',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular searches', style: AppTypography.headlineSmall),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: suggestions.map((s) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(s, style: AppTypography.labelLarge),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
