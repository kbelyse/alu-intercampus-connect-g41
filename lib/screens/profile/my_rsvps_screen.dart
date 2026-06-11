// My RSVPs screen with Going/Interested/Past tab toggle.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../data/mock_data.dart';
import '../../models/event.dart';
import '../../providers/rsvp_provider.dart';
import '../../widgets/common/empty_state.dart';

class MyRsvpsScreen extends StatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen>
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
    final rsvp = context.watch<RsvpProvider>();

    final goingIds = rsvp.getEventIdsByStatus(RsvpStatus.going);
    final interestedIds =
        rsvp.getEventIdsByStatus(RsvpStatus.interested);
    final now = DateTime.now();

    final goingEvents = mockEvents
        .where((e) => goingIds.contains(e.id) && e.startDate.isAfter(now))
        .toList();
    final interestedEvents = mockEvents
        .where((e) =>
            interestedIds.contains(e.id) && e.startDate.isAfter(now))
        .toList();
    final pastEvents = mockEvents
        .where((e) =>
            (goingIds.contains(e.id) || interestedIds.contains(e.id)) &&
            e.startDate.isBefore(now))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(LucideIcons.arrowLeft,
              color: AppColors.textPrimary),
        ),
        title: Text('My RSVPs',
            style: Theme.of(context).textTheme.headlineSmall),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: const [
            Tab(text: 'Going'),
            Tab(text: 'Interested'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RsvpList(
              events: goingEvents, status: RsvpStatus.going),
          _RsvpList(
              events: interestedEvents,
              status: RsvpStatus.interested),
          _RsvpList(events: pastEvents, isPast: true),
        ],
      ),
    );
  }
}

class _RsvpList extends StatelessWidget {
  final List<Event> events;
  final RsvpStatus? status;
  final bool isPast;

  const _RsvpList({
    required this.events,
    this.status,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const EmptyState(
        message: 'Nothing here yet.',
        icon: LucideIcons.calendarX,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: events.length,
      itemBuilder: (context, i) {
        final event = events[i];
        final color =
            kCategoryColors[event.category] ?? AppColors.primary;
        return Opacity(
          opacity: isPast ? 0.55 : 1.0,
          child: Container(
            margin:
                const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.card),
                        bottomLeft:
                            Radius.circular(AppRadius.card),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(event.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  '${DateFormat('MMM d').format(event.startDate)} · ${event.campus}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          _StatusBadge(
                              status: status, isPast: isPast),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RsvpStatus? status;
  final bool isPast;

  const _StatusBadge({this.status, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    if (isPast) {
      bg = AppColors.neutralTag;
      fg = AppColors.textSecondary;
      label = 'Past';
    } else if (status == RsvpStatus.going) {
      bg = AppColors.success.withOpacity(0.15);
      fg = AppColors.success;
      label = 'Going';
    } else {
      bg = AppColors.primary.withOpacity(0.15);
      fg = AppColors.primary;
      label = 'Interested';
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: fg, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
