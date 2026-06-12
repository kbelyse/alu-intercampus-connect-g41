import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/primary_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Set<String> _selectedInterests = {};

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      emoji: '🔍',
      title: 'Discover Opportunities',
      subtitle:
          'From internships to hackathons, find every opportunity that moves your career forward — all in one place.',
      color: AppColors.primary,
      gradient: AppColors.primaryGradient,
    ),
    _OnboardingSlide(
      emoji: '👥',
      title: 'Connect & Collaborate',
      subtitle:
          'Join vibrant communities, find co-founders, and build meaningful relationships across the ALU ecosystem.',
      color: AppColors.secondary,
      gradient: AppColors.secondaryGradient,
    ),
    _OnboardingSlide(
      emoji: '🚀',
      title: 'Grow Your Impact',
      subtitle:
          'Track your journey, earn leadership points, and build the ALU identity that opens every door.',
      color: AppColors.success,
      gradient: LinearGradient(
        colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _finish() {
    ref.read(userProvider.notifier).updateInterests(_selectedInterests.toList());
    ref.read(isOnboardedProvider.notifier).state = true;
    context.go('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page dots
                  Row(
                    children: List.generate(_slides.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? _slides[_currentPage].color
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Skip',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  if (index == _slides.length - 1) {
                    return _InterestSelectionPage(
                      slide: _slides[index],
                      selectedInterests: _selectedInterests,
                      onToggle: (interest) {
                        setState(() {
                          if (_selectedInterests.contains(interest)) {
                            _selectedInterests.remove(interest);
                          } else {
                            _selectedInterests.add(interest);
                          }
                        });
                      },
                    );
                  }
                  return _SlidePage(slide: _slides[index]);
                },
              ),
            ),

            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: isLastPage
                  ? PrimaryButton(
                      label: _selectedInterests.isEmpty
                          ? 'Continue'
                          : 'Get Started (${_selectedInterests.length} selected)',
                      onPressed: _finish,
                    )
                  : PrimaryButton(
                      label: 'Continue',
                      onPressed: _next,
                      backgroundColor: _slides[_currentPage].color,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _OnboardingSlide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: slide.gradient,
              borderRadius: BorderRadius.circular(44),
              boxShadow: [
                BoxShadow(
                  color: slide.color.withOpacity(0.3),
                  blurRadius: 60,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Center(
              child: Text(slide.emoji, style: const TextStyle(fontSize: 60)),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.7, 0.7),
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 400.ms),

          const SizedBox(height: 48),

          Text(
            slide.title,
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(
                begin: 0.3,
                delay: 150.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 16),

          Text(
            slide.subtitle,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

class _InterestSelectionPage extends StatelessWidget {
  final _OnboardingSlide slide;
  final Set<String> selectedInterests;
  final ValueChanged<String> onToggle;

  const _InterestSelectionPage({
    required this.slide,
    required this.selectedInterests,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: slide.gradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(slide.emoji, style: const TextStyle(fontSize: 32)),
            ),
          ).animate().scale(
                begin: const Offset(0.7, 0.7),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 24),

          Text(slide.title, style: AppTypography.displaySmall)
              .animate()
              .fadeIn(delay: 100.ms),

          const SizedBox(height: 8),

          Text(
            'Select at least 3 interests to personalize your experience.',
            style: AppTypography.bodyMedium,
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 24),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppConstants.allInterests.map((interest) {
              final isSelected = selectedInterests.contains(interest);
              return GestureDetector(
                onTap: () => onToggle(interest),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : AppColors.surface,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    interest,
                    style: AppTypography.labelLarge.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 16),

          if (selectedInterests.isNotEmpty)
            Text(
              '${selectedInterests.length} interest${selectedInterests.length == 1 ? '' : 's'} selected — your feed is being personalized',
              style: AppTypography.caption.copyWith(color: AppColors.success),
            ).animate().fadeIn(),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final LinearGradient gradient;

  const _OnboardingSlide({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
  });
}
