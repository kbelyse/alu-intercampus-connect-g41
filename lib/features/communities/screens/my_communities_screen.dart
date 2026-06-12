import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/communities_provider.dart';
import '../../../shared/widgets/community_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class MyCommunitiesScreen extends ConsumerWidget {
  const MyCommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joined = ref.watch(joinedCommunitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('My Communities', style: AppTypography.headlineMedium),
            Text('${joined.length} joined', style: AppTypography.bodySmall),
          ],
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.go('/communities'),
            child: Padding(
              padding: const EdgeInsets.only(right: AppConstants.paddingLG),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Text(
                  'Discover',
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
      body: joined.isEmpty
          ? EmptyStateWidget(
              emoji: '👥',
              title: 'No communities yet',
              subtitle: 'Join communities to connect with students who share your interests',
              actionLabel: 'Discover Communities',
              onAction: () => context.go('/communities'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingLG),
              physics: const BouncingScrollPhysics(),
              itemCount: joined.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CommunityCard(
                  community: joined[i],
                  onTap: () => context.push('/community/${joined[i].id}'),
                ).animate(delay: Duration(milliseconds: i * 60))
                    .fadeIn(duration: 300.ms),
              ),
            ),
    );
  }
}
