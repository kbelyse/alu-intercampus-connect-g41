// Profile screen with avatar, stats, badges, and menu list.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/avatar_circle.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _menuItems = [
    _MenuItem(icon: LucideIcons.fileText, label: 'My Posts'),
    _MenuItem(icon: LucideIcons.bookmark, label: 'Saved Items'),
    _MenuItem(icon: LucideIcons.calendarCheck, label: 'My RSVPs', route: '/profile/rsvps'),
    _MenuItem(icon: LucideIcons.bell, label: 'Notifications', route: '/profile/notifications'),
    _MenuItem(icon: LucideIcons.settings, label: 'Account Settings'),
    _MenuItem(icon: LucideIcons.helpCircle, label: 'Help & Support'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(
                children: [
                  Text('Profile',
                      style: Theme.of(context).textTheme.displaySmall),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.settings,
                        color: AppColors.textPrimary,
                        size: AppIconSize.standalone),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Avatar and name
            Center(
              child: Column(
                children: [
                  AvatarCircle(
                    initials: user.initials,
                    size: 100,
                    fontSize: 28,
                    imageUrl: user.avatarUrl,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.campus,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg, vertical: 6),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Stats row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _StatItem(
                    value: '${user.eventsAttended}',
                    label: 'Events',
                    onTap: () {},
                  ),
                  _vDivider(),
                  _StatItem(
                    value: '${user.communities}',
                    label: 'Communities',
                    onTap: () {},
                  ),
                  _vDivider(),
                  _StatItem(
                    value: '${user.connections}',
                    label: 'Connections',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('My Badges',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
                itemCount: user.badges.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final icons = ['🎖️', '🎤', '🏗️'];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.elevated,
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${icons[i % icons.length]} ${user.badges[i]}',
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border, indent: 16, endIndent: 16),
            const SizedBox(height: AppSpacing.sm),

            // Menu items
            ..._menuItems.map(
              (item) => _MenuRow(
                item: item,
                onTap: () {
                  if (item.route != null) context.push(item.route!);
                },
              ),
            ),
            const Divider(color: AppColors.border, indent: 16, endIndent: 16),

            // Log out
            GestureDetector(
              onTap: () {
                context.read<AuthProvider>().logout();
                context.go('/splash');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
                child: const Row(
                  children: [
                    Icon(LucideIcons.logOut, color: AppColors.error, size: AppIconSize.inline),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(
        height: 40,
        width: 1,
        color: AppColors.border,
      );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback onTap;

  const _StatItem({
    required this.value,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 3),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _MenuRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(item.icon,
                  color: AppColors.primary, size: AppIconSize.inline),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(item.label,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            const Icon(LucideIcons.chevronRight,
                color: AppColors.textSecondary, size: AppIconSize.inline),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? route;

  const _MenuItem({required this.icon, required this.label, this.route});
}
