import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/recommendations_provider.dart';
import '../../../shared/providers/opportunities_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/opportunity_card.dart';

class SavedOpportunitiesScreen extends ConsumerStatefulWidget {
  const SavedOpportunitiesScreen({super.key});

  @override
  ConsumerState<SavedOpportunitiesScreen> createState() =>
      _SavedOpportunitiesScreenState();
}

class _SavedOpportunitiesScreenState
    extends ConsumerState<SavedOpportunitiesScreen>
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
    final savedEvents = ref.watch(savedEventsProvider);
    final savedOpps = ref.watch(savedOpportunitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Saved', style: AppTypography.headlineMedium),
            Text('${savedEvents.length + savedOpps.length} items',
                style: AppTypography.bodySmall),
          ],
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.titleSmall,
          tabs: [
            Tab(text: 'Events (${savedEvents.length})'),
            Tab(text: 'Opportunities (${savedOpps.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Saved Events
          savedEvents.isEmpty
              ? const EmptyStateWidget(
                  emoji: '🔖',
                  title: 'No saved events',
                  subtitle:
                      'Tap the bookmark icon on any event to save it here',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingLG),
                  physics: const BouncingScrollPhysics(),
                  itemCount: savedEvents.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: EventCard(
                      event: savedEvents[i],
                      onTap: () =>
                          context.push('/opportunity/${savedEvents[i].id}'),
                    ).animate(delay: Duration(milliseconds: i * 60))
                        .fadeIn(duration: 300.ms),
                  ),
                ),

          // Saved Opportunities
          savedOpps.isEmpty
              ? const EmptyStateWidget(
                  emoji: '💼',
                  title: 'No saved opportunities',
                  subtitle: 'Save internships, fellowships, and grants here',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingLG),
                  physics: const BouncingScrollPhysics(),
                  itemCount: savedOpps.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: OpportunityCard(opportunity: savedOpps[i])
                        .animate(delay: Duration(milliseconds: i * 60))
                        .fadeIn(duration: 300.ms),
                  ),
                ),
        ],
      ),
    );
  }
}
