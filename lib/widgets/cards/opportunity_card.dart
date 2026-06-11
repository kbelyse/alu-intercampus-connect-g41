// Opportunity card with left colored bar, title, deadline, campus, and type chip.
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../models/opportunity.dart';
import '../common/shimmer_box.dart';
import 'package:intl/intl.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback? onTap;

  const OpportunityCard({super.key, required this.opportunity, this.onTap});

  Color get _color =>
      kCategoryColors[opportunity.category] ?? AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
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
                  color: _color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.card),
                    bottomLeft: Radius.circular(AppRadius.card),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              opportunity.title,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: opportunity.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const ShimmerBox(width: 60, height: 60, borderRadius: 8),
                              errorWidget: (context, url, error) => Container(
                                width: 60,
                                height: 60,
                                color: _color.withValues(alpha: 0.2),
                                child: Icon(LucideIcons.image,
                                    color: _color, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.clock,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Deadline: ${DateFormat('MMM d').format(opportunity.deadline)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          const Icon(
                            LucideIcons.mapPin,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            opportunity.campus,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _color.withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.chip),
                            ),
                            child: Text(
                              opportunity.type,
                              style: TextStyle(
                                color: _color,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
