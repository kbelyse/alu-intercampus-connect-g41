import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/recommendations_provider.dart';
import '../../../shared/providers/events_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class MyEventsScreen extends ConsumerStatefulWidget {
  const MyEventsScreen({super.key});

  @override
  ConsumerState<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends ConsumerState<MyEventsScreen>
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
    final rsvpedEvents = ref.watch(rsvpedEventsProvider);
    final savedEvents = ref.watch(savedEventsProvider);
    final allEvents = ref.watch(allEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('My Events', style: AppTypography.headlineMedium),
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
          labelStyle: AppTypography.titleSmall.copyWith(fontSize: 13),
          tabs: [
            Tab(text: "RSVP'd (${rsvpedEvents.length})"),
            Tab(text: 'Saved (${savedEvents.length})'),
            Tab(text: 'All (${allEvents.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _EventList(
            events: rsvpedEvents,
            emptyEmoji: '📅',
            emptyTitle: 'No RSVPs yet',
            emptySubtitle:
                'RSVP to events to see them here. Browse upcoming events on the Home screen.',
          ),
          _EventList(
            events: savedEvents,
            emptyEmoji: '🔖',
            emptyTitle: 'No saved events',
            emptySubtitle: 'Bookmark events by tapping the save icon',
          ),
          _EventList(events: allEvents),
        ],
      ),
    );
  }
}

class _EventList extends ConsumerWidget {
  final List<dynamic> events;
  final String? emptyEmoji;
  final String? emptyTitle;
  final String? emptySubtitle;

  const _EventList({
    required this.events,
    this.emptyEmoji,
    this.emptyTitle,
    this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (events.isEmpty && emptyEmoji != null) {
      return EmptyStateWidget(
        emoji: emptyEmoji!,
        title: emptyTitle!,
        subtitle: emptySubtitle!,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingLG),
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: EventCard(
          event: events[i],
          onTap: () => context.push('/opportunity/${events[i].id}'),
        ).animate(delay: Duration(milliseconds: i * 60))
            .fadeIn(duration: 300.ms),
      ),
    );
  }
}
