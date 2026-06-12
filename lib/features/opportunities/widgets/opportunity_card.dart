import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/opportunity_model.dart';
import '../../../shared/providers/user_provider.dart';

class OpportunityCard extends ConsumerWidget {
  final OpportunityModel opportunity;
  final VoidCallback? onTap;

  const OpportunityCard({super.key, required this.opportunity, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isSaved = user.savedOpportunityIds.contains(opportunity.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: opportunity.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(width: 56, height: 56, color: AppColors.elevated),
                errorWidget: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.elevated,
                  child: const Icon(Icons.business, color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(opportunity.title,
                                style: AppTypography.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(opportunity.company,
                                style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isSaved) {
                            ref.read(userProvider.notifier)
                                .unsaveOpportunity(opportunity.id);
                          } else {
                            ref.read(userProvider.notifier)
                                .saveOpportunity(opportunity.id);
                          }
                        },
                        child: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          color: isSaved
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Tag(
                        label: opportunity.typeLabel,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      if (opportunity.isRemote)
                        const _Tag(label: 'Remote', color: AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 11, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('Due ${opportunity.deadline}',
                          style: AppTypography.caption.copyWith(
                              color: AppColors.primary)),
                      const SizedBox(width: 10),
                      const Icon(Icons.monetization_on_outlined,
                          size: 11, color: AppColors.success),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(opportunity.compensation,
                            style: AppTypography.caption,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
