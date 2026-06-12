import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/notifications_provider.dart';
import '../../../shared/models/notification_model.dart';
import '../../../shared/widgets/primary_button.dart';

class CreateOpportunityScreen extends ConsumerStatefulWidget {
  const CreateOpportunityScreen({super.key});

  @override
  ConsumerState<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends ConsumerState<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;
  String _selectedType = 'Event';
  String _selectedCampus = 'Kigali';
  final Set<String> _selectedCategories = {};

  static const List<String> _types = [
    'Event',
    'Workshop',
    'Hackathon',
    'Community',
    'Opportunity',
    'Startup Post',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    ref.read(notificationsProvider.notifier).addNotification(
          NotificationModel(
            id: 'notif_new_${DateTime.now().millisecondsSinceEpoch}',
            title: '${_selectedType} posted!',
            body: '"${_titleController.text}" is now live on ALU Connect.',
            timestamp: DateTime.now(),
            isRead: false,
            type: NotificationType.system,
          ),
        );
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your post is live! 🎉'),
        duration: Duration(seconds: 3),
      ),
    );
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            snap: true,
            elevation: 0,
            titleSpacing: AppConstants.paddingLG,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Create Post', style: AppTypography.headlineMedium),
                Text('Share with the ALU community', style: AppTypography.bodySmall),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type selector
                    Text('What are you posting?',
                            style: AppTypography.headlineSmall)
                        .animate()
                        .fadeIn(duration: 300.ms),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _types.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final type = _types[i];
                          final isSelected = type == _selectedType;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedType = type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                type,
                                style: AppTypography.labelLarge.copyWith(
                                  color: isSelected
                                      ? AppColors.background
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 50.ms),

                    const SizedBox(height: 28),

                    _FieldLabel('Title'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'e.g., ALU AI Workshop 2025',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Title is required' : null,
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 20),

                    _FieldLabel('Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descController,
                      style: AppTypography.bodyLarge,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Describe your event, opportunity, or idea...',
                        alignLabelWithHint: true,
                      ),
                      validator: (v) =>
                          v == null || v.length < 20
                              ? 'Add a description (min 20 chars)'
                              : null,
                    ).animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: 20),

                    _FieldLabel('Location'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _locationController,
                      style: AppTypography.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'Room B3, Main Hall, or Virtual',
                        prefixIcon: Icon(Icons.location_on_outlined,
                            color: AppColors.textSecondary, size: 18),
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 20),

                    _FieldLabel('Campus'),
                    const SizedBox(height: 8),
                    Row(
                      children: AppConstants.campuses.map((campus) {
                        final isSelected = campus == _selectedCampus;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCampus = campus),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(
                                  right: campus == AppConstants.campuses.first
                                      ? 8
                                      : 0),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Text(
                                campus,
                                style: AppTypography.titleSmall.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 250.ms),

                    const SizedBox(height: 20),

                    _FieldLabel('Categories'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.allInterests.take(10).map((cat) {
                        final isSelected = _selectedCategories.contains(cat);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedCategories.remove(cat);
                              } else {
                                _selectedCategories.add(cat);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: AppTypography.labelSmall.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 36),

                    // Add Image button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.border,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined,
                                color: AppColors.textSecondary, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Add Cover Image',
                              style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 350.ms),

                    const SizedBox(height: 32),

                    PrimaryButton(
                      label: 'Publish $_selectedType',
                      onPressed: _submit,
                      isLoading: _isLoading,
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
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
