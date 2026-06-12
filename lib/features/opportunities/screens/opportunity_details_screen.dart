import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/events_provider.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/user_avatar.dart';

class OpportunityDetailsScreen extends ConsumerWidget {
  final String eventId;

  const OpportunityDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventByIdProvider(eventId));
    final user = ref.watch(userProvider);

    if (event == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background),
        body: const Center(child: Text('Event not found')),
      );
    }

    final isRsvped = user.rsvpedEventIds.contains(event.id);
    final isSaved = user.savedEventIds.contains(event.id);
    final spotsLeft = event.maxAttendees - event.attendeeCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary, size: 18),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      if (isSaved) {
                        ref.read(userProvider.notifier).unsaveEvent(event.id);
                        _showSnack(context, 'Removed from saved');
                      } else {
                        ref.read(userProvider.notifier).saveEvent(event.id);
                        _showSnack(context, 'Saved!');
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: isSaved ? AppColors.primary : AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showSnack(context, 'Link copied!'),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.ios_share_rounded,
                          color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'event_${event.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: event.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: AppColors.elevated),
                          errorWidget: (_, __, ___) =>
                              Container(color: AppColors.elevated),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.background.withOpacity(0.95),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.3, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: AppConstants.paddingLG,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              event.typeLabel,
                              style: AppTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppConstants.paddingLG, 24,
                      AppConstants.paddingLG, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & organizer
                      Text(event.title, style: AppTypography.displaySmall)
                          .animate()
                          .fadeIn(duration: 400.ms),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          UserAvatar(
                            imageUrl: event.organizerAvatarUrl,
                            name: event.organizer,
                            size: 32,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Organized by',
                                  style: AppTypography.caption),
                              Text(event.organizer,
                                  style: AppTypography.titleSmall),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(delay: 50.ms, duration: 400.ms),

                      const SizedBox(height: 24),

                      // Info cards row
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.calendar_today_outlined,
                              label: 'Date',
                              value: DateFormat('MMM d, yyyy').format(event.date),
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.access_time_outlined,
                              label: 'Time',
                              value: DateFormat('h:mm a').format(event.date),
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.location_on_outlined,
                              label: 'Location',
                              value: event.location,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.people_outline,
                              label: 'Capacity',
                              value: '$spotsLeft spots left',
                              color: spotsLeft < 20
                                  ? AppColors.error
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                      const SizedBox(height: 28),

                      // Description
                      Text('About this event', style: AppTypography.headlineSmall)
                          .animate()
                          .fadeIn(delay: 200.ms),
                      const SizedBox(height: 12),
                      Text(event.description,
                          style: AppTypography.bodyMedium.copyWith(height: 1.7))
                          .animate()
                          .fadeIn(delay: 220.ms),

                      const SizedBox(height: 28),

                      // Tags
                      Text('Categories', style: AppTypography.headlineSmall)
                          .animate()
                          .fadeIn(delay: 240.ms),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: event.categories.map((cat) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Text(
                              cat,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ).animate().fadeIn(delay: 260.ms),

                      // Attendees
                      if (event.participantAvatars.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        Text('Who\'s attending', style: AppTypography.headlineSmall)
                            .animate()
                            .fadeIn(delay: 280.ms),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            AvatarStack(
                              avatarUrls: event.participantAvatars,
                              size: 36,
                              maxVisible: 5,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${event.attendeeCount} students registered',
                                  style: AppTypography.titleSmall,
                                ),
                                Text(
                                  '${event.campus} campus',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ).animate().fadeIn(delay: 300.ms),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  AppConstants.paddingLG,
                  16,
                  AppConstants.paddingLG,
                  MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: const Border(
                    top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d').format(event.date),
                          style: AppTypography.bodySmall,
                        ),
                        Text(
                          isRsvped ? 'You\'re going! 🎉' : 'Free · Open to all',
                          style: AppTypography.titleSmall.copyWith(
                            color: isRsvped
                                ? AppColors.success
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 140,
                    child: PrimaryButton(
                      label: isRsvped ? 'Cancel RSVP' : 'RSVP Now',
                      isFullWidth: false,
                      backgroundColor:
                          isRsvped ? AppColors.elevated : AppColors.primary,
                      onPressed: () {
                        if (isRsvped) {
                          ref.read(userProvider.notifier).unRsvpEvent(event.id);
                          _showSnack(context, 'RSVP cancelled');
                        } else {
                          ref.read(userProvider.notifier).rsvpEvent(event.id);
                          _showSnack(context, 'RSVP confirmed! See you there 🎉');
                        }
                      },
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

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
