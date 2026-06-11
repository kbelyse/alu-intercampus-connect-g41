// Notifications screen with filter chips, grouped by Today/Yesterday/Earlier.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/notification_item.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/cards/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _filters = [
    (label: 'All', type: null),
    (label: 'Events', type: NotificationType.event),
    (label: 'Communities', type: NotificationType.community),
    (label: 'Mentions', type: NotificationType.mention),
  ];

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NotificationProvider>();

    final now = DateTime.now();
    final today = prov.filtered
        .where((n) => now.difference(n.timestamp).inHours < 24)
        .toList();
    final yesterday = prov.filtered
        .where((n) {
          final diff = now.difference(n.timestamp);
          return diff.inHours >= 24 && diff.inHours < 48;
        })
        .toList();
    final earlier = prov.filtered
        .where((n) => now.difference(n.timestamp).inHours >= 48)
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
        title: Text('Notifications',
            style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          TextButton(
            onPressed: prov.markAllRead,
            child: const Text(
              'Mark all read',
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              itemCount: _filters.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) {
                final f = _filters[i];
                final isSelected = prov.activeFilter == f.type;
                return GestureDetector(
                  onTap: () => prov.setFilter(f.type),
                  child: AnimatedContainer(
                    duration: AppDuration.fast,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppRadius.chip),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      f.label,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: prov.filtered.isEmpty
                ? const EmptyState(
                    message: 'No notifications yet.',
                    icon: LucideIcons.bell,
                  )
                : ListView(
                    padding: const EdgeInsets.only(
                        bottom: AppSpacing.xxl),
                    children: [
                      if (today.isNotEmpty) ...[
                        _GroupHeader(title: 'Today'),
                        ...today.map(
                          (n) => NotificationCard(
                            item: n,
                            onTap: () => prov.markRead(n.id),
                          ),
                        ),
                      ],
                      if (yesterday.isNotEmpty) ...[
                        _GroupHeader(title: 'Yesterday'),
                        ...yesterday.map(
                          (n) => NotificationCard(
                            item: n,
                            onTap: () => prov.markRead(n.id),
                          ),
                        ),
                      ],
                      if (earlier.isNotEmpty) ...[
                        _GroupHeader(title: 'Earlier'),
                        ...earlier.map(
                          (n) => NotificationCard(
                            item: n,
                            onTap: () => prov.markRead(n.id),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;

  const _GroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
