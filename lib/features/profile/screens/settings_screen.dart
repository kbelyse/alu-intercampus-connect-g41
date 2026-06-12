import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/user_avatar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Settings', style: AppTypography.headlineSmall),
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
            // Account section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  UserAvatar(
                    imageUrl: user.avatarUrl,
                    name: user.name,
                    size: 52,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: AppTypography.titleMedium),
                        Text(user.email, style: AppTypography.bodySmall),
                        Text(
                          '${user.campus} Campus · Cohort ${user.cohort}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _SectionTitle('Account'),
            _SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Edit Profile',
              onTap: () => context.push('/edit-profile'),
            ),
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.mail_outline_rounded,
              title: 'Email',
              value: user.email,
              onTap: () {},
            ),

            const SizedBox(height: 24),

            _SectionTitle('Notifications'),
            _SettingsToggle(title: 'Push Notifications', initialValue: true),
            _SettingsToggle(title: 'Event Reminders', initialValue: true),
            _SettingsToggle(title: 'Community Updates', initialValue: false),
            _SettingsToggle(title: 'New Opportunities', initialValue: true),

            const SizedBox(height: 24),

            _SectionTitle('Privacy'),
            _SettingsTile(
              icon: Icons.visibility_outlined,
              title: 'Profile Visibility',
              value: 'ALU Students',
              onTap: () {},
            ),
            _SettingsToggle(title: 'Show in Campus Pulse', initialValue: true),

            const SizedBox(height: 24),

            _SectionTitle('About'),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'About ALU Connect',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Logout
            GestureDetector(
              onTap: () {
                ref.read(isLoggedInProvider.notifier).state = false;
                ref.read(isOnboardedProvider.notifier).state = false;
                context.go('/splash');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: AppTypography.titleSmall.copyWith(
                          color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                'ALU Connect v1.0.0',
                style: AppTypography.caption,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.elevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: AppTypography.titleSmall),
            ),
            if (value != null)
              Text(value!, style: AppTypography.bodySmall),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 12, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatefulWidget {
  final String title;
  final bool initialValue;
  const _SettingsToggle({required this.title, required this.initialValue});

  @override
  State<_SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<_SettingsToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.title, style: AppTypography.titleSmall),
          ),
          Switch(
            value: _value,
            onChanged: (v) => setState(() => _value = v),
            activeColor: AppColors.primary,
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primaryLight;
              }
              return AppColors.elevated;
            }),
          ),
        ],
      ),
    );
  }
}
