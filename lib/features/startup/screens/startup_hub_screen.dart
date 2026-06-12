import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/startup_provider.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/user_avatar.dart';

class StartupHubScreen extends ConsumerWidget {
  const StartupHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startups = ref.watch(startupsProvider);
    final collabRequests = ref.watch(collaborationRequestsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Startup Corner', style: AppTypography.headlineMedium),
            Text('Build your venture', style: AppTypography.bodySmall),
          ],
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1D2E), Color(0xFF222540)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.secondaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                            child: Text('💡', style: TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ALU Startup Corner',
                        style: AppTypography.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Connect with student founders, find collaborators, and discover startup opportunities across ALU\'s two campuses.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _StatPill(value: '${startups.length}', label: 'Startups'),
                      const SizedBox(width: 10),
                      _StatPill(
                          value: '${collabRequests.length}',
                          label: 'Open Roles'),
                      const SizedBox(width: 10),
                      _StatPill(
                          value: startups
                              .where((s) => s.isLookingForCofounder)
                              .length
                              .toString(),
                          label: 'Need Co-founder'),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 32),

            // Student Startups
            const SectionHeader(
              title: 'Student Startups',
              subtitle: 'Ventures built by ALU students',
            ),
            const SizedBox(height: 16),

            ...startups.asMap().entries.map((entry) {
              final startup = entry.value;
              return _StartupCard(startup: startup)
                  .animate(delay: Duration(milliseconds: entry.key * 80))
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
            }),

            const SizedBox(height: 32),

            // Collaboration Requests
            SectionHeader(
              title: 'Looking to Collaborate',
              subtitle: 'Open roles & collaboration requests',
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${collabRequests.length} active',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ...collabRequests.asMap().entries.map((entry) {
              final request = entry.value;
              return _CollabRequestCard(request: request)
                  .animate(
                      delay: Duration(milliseconds: 300 + entry.key * 80))
                  .fadeIn(duration: 400.ms);
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StartupCard extends StatelessWidget {
  final dynamic startup;
  const _StartupCard({required this.startup});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: startup.logoUrl as String,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(width: 52, height: 52, color: AppColors.elevated),
                  errorWidget: (_, __, ___) => Container(
                    width: 52,
                    height: 52,
                    color: AppColors.elevated,
                    child: const Icon(Icons.business, color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(startup.name as String,
                              style: AppTypography.titleLarge),
                        ),
                        _StageBadge(stage: startup.stage as String),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(startup.tagline as String,
                        style: AppTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(startup.description as String,
              style: AppTypography.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (startup.tags as List<String>).take(3).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.elevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(tag,
                    style: AppTypography.caption.copyWith(fontSize: 10)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              UserAvatar(
                imageUrl: startup.founderAvatar as String,
                name: startup.founderName as String,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                startup.founderName as String,
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              if ((startup.openRoles as List).isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(startup.openRoles as List).length} open role${(startup.openRoles as List).length == 1 ? '' : 's'}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CollabRequestCard extends StatelessWidget {
  final dynamic request;
  const _CollabRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(
                imageUrl: request.userAvatar as String,
                name: request.userName as String,
                size: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.userName as String, style: AppTypography.titleSmall),
                    Text(request.role as String,
                        style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Connect',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(request.description as String,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (request.skills as List<String>).take(4).map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: Text(
                  skill,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondary,
                    fontSize: 10,
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

class _StageBadge extends StatelessWidget {
  final String stage;
  const _StageBadge({required this.stage});

  Color get color => switch (stage) {
    'Pre-seed' => AppColors.textSecondary,
    'Seed' => AppColors.primary,
    'Series A' => AppColors.success,
    _ => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        stage,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  const _StatPill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(label, style: AppTypography.caption.copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}
