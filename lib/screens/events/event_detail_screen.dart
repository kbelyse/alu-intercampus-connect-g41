// Event detail screen with hero header, info rows, organizer, and RSVP buttons.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../data/mock_data.dart';
import '../../models/event.dart';
import '../../providers/rsvp_provider.dart';
import '../../widgets/common/avatar_circle.dart';
import '../../widgets/common/shimmer_box.dart';
import '../../widgets/cards/event_card.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _expanded = false;

  Event? get _event {
    try {
      return mockEvents.firstWhere((e) => e.id == widget.eventId);
    } catch (_) {
      return null;
    }
  }

  Color get _color =>
      kCategoryColors[_event?.category] ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final event = _event;
    if (event == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: const Center(
            child: Text('Event not found',
                style: TextStyle(color: AppColors.textSecondary))),
      );
    }

    final rsvp = context.watch<RsvpProvider>();
    final status = rsvp.getStatus(event.id);
    final relatedEvents = mockEvents
        .where((e) =>
            e.id != event.id &&
            (e.category == event.category || e.campus == event.campus))
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                expandedHeight: 260,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.arrowLeft,
                        color: Colors.white, size: 20),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.share2,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'event_hero_${event.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: event.imageUrl,
                          fit: BoxFit.cover,
                          height: 250,
                          placeholder: (context, url) => const ShimmerBox(
                            width: double.infinity,
                            height: 250,
                            borderRadius: 0,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: _color.withValues(alpha: 0.3),
                          ),
                        ),
                        // Gradient overlay transparent to black at bottom
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSpacing.xl, 80, AppSpacing.xl, AppSpacing.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                event.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category chips
                      Wrap(
                        spacing: AppSpacing.sm,
                        children: [
                          ...event.tags.map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _color.withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.chip),
                              ),
                              child: Text(
                                '#$t',
                                style: TextStyle(
                                    color: _color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Info rows
                      _InfoRow(
                        icon: LucideIcons.calendar,
                        text: DateFormat('EEEE, MMM d, yyyy · h:mm a')
                            .format(event.startDate),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                        icon: LucideIcons.mapPin,
                        text:
                            '${event.campus} · ${event.location.isNotEmpty ? event.location : 'TBA'}',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                        icon: LucideIcons.users,
                        text:
                            '${event.attendeeCount} going · ${event.interestedCount} interested',
                      ),
                      if (event.endDate != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _InfoRow(
                          icon: LucideIcons.clock,
                          text:
                              'Ends ${DateFormat('MMM d').format(event.endDate!)}',
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),

                      // Organizer row
                      Row(
                        children: [
                          AvatarCircle(
                            initials: event.organizer
                                .substring(0, 2)
                                .toUpperCase(),
                            size: 36,
                            color: _color,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Organized by',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(event.organizer,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.chip),
                            ),
                            child: const Text(
                              'Follow',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),

                      // Description
                      Text('About this event',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _expanded
                            ? event.description
                            : event.description.length > 180
                                ? '${event.description.substring(0, 180)}...'
                                : event.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                      ),
                      if (event.description.length > 180)
                        GestureDetector(
                          onTap: () =>
                              setState(() => _expanded = !_expanded),
                          child: Text(
                            _expanded ? 'Show less' : 'Read more',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: AppSpacing.lg),

                      // Who's going
                      Text("Who's going",
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          ...['AU', 'KA', 'FD', 'AS', 'CO'].map(
                            (i) => Transform.translate(
                              offset: Offset(
                                  -(['AU', 'KA', 'FD', 'AS', 'CO']
                                              .indexOf(i) *
                                          10)
                                      .toDouble(),
                                  0),
                              child: AvatarCircle(
                                initials: i,
                                size: 34,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '+${event.attendeeCount - 5} others',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Related events
                      if (relatedEvents.isNotEmpty) ...[
                        Text('You might also like',
                            style:
                                Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedEvents.length,
                            itemBuilder: (context, i) => EventCard(
                              event: relatedEvents[i],
                              isCompact: true,
                              onTap: () => context.pushReplacement(
                                  '/events/${relatedEvents[i].id}'),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky bottom RSVP buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg +
                    MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: const Border(
                    top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _RsvpButton(
                      status: status,
                      onGoing: () =>
                          rsvp.setRsvp(event.id, RsvpStatus.going),
                      onCancel: () =>
                          rsvp.clearRsvp(event.id),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => rsvp.setRsvp(
                          event.id, RsvpStatus.interested),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                        side: BorderSide(
                          color: status == RsvpStatus.interested
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.button),
                        ),
                      ),
                      child: Text(
                        status == RsvpStatus.interested
                            ? '★ Interested'
                            : 'Interested',
                        style: TextStyle(
                          color: status == RsvpStatus.interested
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: AppIconSize.inline, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _RsvpButton extends StatelessWidget {
  final RsvpStatus status;
  final VoidCallback onGoing;
  final VoidCallback onCancel;

  const _RsvpButton({
    required this.status,
    required this.onGoing,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isGoing = status == RsvpStatus.going;
    return ElevatedButton(
      onPressed: isGoing ? onCancel : onGoing,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isGoing ? AppColors.success.withValues(alpha: 0.2) : AppColors.primary,
        foregroundColor: isGoing ? AppColors.success : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          side: isGoing
              ? const BorderSide(color: AppColors.success)
              : BorderSide.none,
        ),
      ),
      child: Text(
        isGoing ? '✓ Going · Cancel' : 'RSVP — Going',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}
