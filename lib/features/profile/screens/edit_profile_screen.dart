import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/primary_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _majorController;
  String? _selectedCampus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user.name);
    _bioController = TextEditingController(text: user.bio);
    _majorController = TextEditingController(text: user.major);
    _selectedCampus = user.campus;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    ref.read(userProvider.notifier).updateProfile(
          name: _nameController.text,
          bio: _bioController.text,
          major: _majorController.text,
          campus: _selectedCampus,
        );
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Edit Profile', style: AppTypography.headlineSmall),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  UserAvatar(
                    imageUrl: user.avatarUrl,
                    name: user.name,
                    size: 88,
                    borderColor: AppColors.primary,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.background, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _FieldLabel('Full Name'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: AppTypography.bodyLarge,
              decoration: const InputDecoration(hintText: 'Your full name'),
            ),

            const SizedBox(height: 20),

            _FieldLabel('Major'),
            const SizedBox(height: 8),
            TextField(
              controller: _majorController,
              style: AppTypography.bodyLarge,
              decoration: const InputDecoration(hintText: 'Your program/major'),
            ),

            const SizedBox(height: 20),

            _FieldLabel('Campus'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCampus,
                  isExpanded: true,
                  dropdownColor: AppColors.elevated,
                  style: AppTypography.bodyLarge,
                  items: AppConstants.campuses.map((campus) {
                    return DropdownMenuItem(
                      value: campus,
                      child: Text(campus),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedCampus = v),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _FieldLabel('Bio'),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              style: AppTypography.bodyLarge,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tell your story...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 36),

            PrimaryButton(
              label: 'Save Changes',
              onPressed: _save,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleSmall.copyWith(color: AppColors.textSecondary),
    );
  }
}
