// Persistent bottom navigation shell with 4 tabs and a central FAB.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/notification_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: LucideIcons.home, label: 'Home', path: '/home'),
    _TabItem(icon: LucideIcons.compass, label: 'Explore', path: '/explore'),
    _TabItem(icon: LucideIcons.messageCircle, label: 'Chats', path: '/chats'),
    _TabItem(icon: LucideIcons.user, label: 'Profile', path: '/profile'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/chats')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () => context.push('/create'),
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(LucideIcons.plus, color: Colors.black, size: 26),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: currentIndex,
        tabs: _tabs,
        onTap: (i) {
          if (i < 2) {
            context.go(_tabs[i].path);
          } else {
            context.go(_tabs[i].path);
          }
        },
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // Left two tabs
              ...[0, 1].map((i) => _buildTab(context, i)),
              // FAB spacer
              const SizedBox(width: 72),
              // Right two tabs
              ...[2, 3].map((i) => _buildTab(context, i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index) {
    final tab = tabs[index];
    final isSelected = currentIndex == index;

    Widget iconWidget = Icon(
      tab.icon,
      size: AppIconSize.nav,
      color: isSelected ? AppColors.primary : AppColors.textSecondary,
    );

    // Notification badge on chats tab
    if (index == 2) {
      iconWidget = Consumer<NotificationProvider>(
        builder: (context, notif, _) => Stack(
          clipBehavior: Clip.none,
          children: [
            iconWidget,
            if (notif.unreadCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 3),
            Text(
              tab.label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  final String path;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}
