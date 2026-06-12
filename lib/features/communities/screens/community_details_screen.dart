import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/communities_provider.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/providers/events_provider.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/event_card.dart';

class CommunityDetailsScreen extends ConsumerWidget {
  final String communityId;

  const CommunityDetailsScreen({super.key, required this.communityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final community = ref.watch(communityByIdProvider(communityId));
    final user = ref.watch(userProvider);

    if (community == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background),
        body: const Center(child: Text('Community not found')),
      );
    }

    final isJoined = user.joinedCommunityIds.contains(community.id);
    final relatedEvents = ref.watch(allEventsProvider).where((e) {
      return e.categories.any((cat) => community.tags.contains(cat));
    }).take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 18),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => context.push('/chat/$communityId'),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded,
                      color: AppColors.textPrimary, size: 20),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: community.coverUrl,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: community.imageUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(width: 64, height: 64, color: AppColors.elevated),
                          errorWidget: (_, __, ___) =>
                              Container(width: 64, height: 64, color: AppColors.elevated),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(community.name,
                                      style: AppTypography.headlineMedium),
                                ),
                                if (community.isTrending)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.local_fire_department,
                                            size: 10, color: AppColors.primary),
                                        const SizedBox(width: 3),
                                        Text(
                                          'Trending',
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${community.memberCount} members · ${community.campus}',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      _StatChip(
                          icon: Icons.bar_chart,
                          label: '${community.weeklyPosts} posts/week',
                          color: AppColors.secondary),
                      const SizedBox(width: 10),
                      _StatChip(
                          icon: Icons.schedule_outlined,
                          label: community.lastActivity,
                          color: AppColors.success),
                    ],
                  ).animate().fadeIn(delay: 50.ms),

                  const SizedBox(height: 20),

                  Text(community.description,
                          style: AppTypography.bodyMedium.copyWith(height: 1.7))
                      .animate()
                      .fadeIn(delay: 100.ms),

                  const SizedBox(height: 20),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: community.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.elevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(tag,
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textSecondary)),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 24),

                  // Members preview
                  Text('Members', style: AppTypography.headlineSmall)
                      .animate()
                      .fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      AvatarStack(
                          avatarUrls: community.memberAvatars, size: 36),
                      const SizedBox(width: 12),
                      Text(
                        '${community.memberCount} students',
                        style: AppTypography.titleSmall,
                      ),
                    ],
                  ).animate().fadeIn(delay: 220.ms),

                  if (relatedEvents.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text('Upcoming Events', style: AppTypography.headlineSmall)
                        .animate()
                        .fadeIn(delay: 250.ms),
                    const SizedBox(height: 12),
                    ...relatedEvents.map((event) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: EventCard(
                            event: event,
                            compact: true,
                            onTap: () => context.push('/opportunity/${event.id}'),
                          ).animate(delay: 280.ms).fadeIn(duration: 400.ms),
                        )),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            AppConstants.paddingLG,
            12,
            AppConstants.paddingLG,
            MediaQuery.of(context).padding.bottom + 12),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: isJoined ? 'Leave Community' : 'Join Community',
                backgroundColor:
                    isJoined ? AppColors.elevated : AppColors.primary,
                onPressed: () {
                  if (isJoined) {
                    ref
                        .read(communitiesProvider.notifier)
                        .leaveCommunity(community.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Left community')),
                    );
                  } else {
                    ref
                        .read(communitiesProvider.notifier)
                        .joinCommunity(community.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Joined ${community.name}! 🎉')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => context.push('/chat/$communityId'),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded,
                    color: AppColors.textPrimary, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: AppTypography.caption.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
