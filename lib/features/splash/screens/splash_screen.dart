import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/providers/user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    final isLoggedIn = ref.read(isLoggedInProvider);
    final isOnboarded = ref.read(isOnboardedProvider);
    if (isLoggedIn) {
      context.go('/home');
    } else if (isOnboarded) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background orbs
          Positioned(
            top: -100,
            right: -80,
            child: _Orb(color: AppColors.secondary.withOpacity(0.15), size: 320)
                .animate(
                  onPlay: (c) => c.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 3000.ms,
                ),
          ),
          Positioned(
            bottom: -120,
            left: -60,
            child: _Orb(color: AppColors.primary.withOpacity(0.12), size: 280)
                .animate(
                  onPlay: (c) => c.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.15, 1.15),
                  duration: 2500.ms,
                ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 40,
                        spreadRadius: 0,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('A', style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    )),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                Text(
                  'ALU Connect',
                  style: AppTypography.displaySmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(
                      begin: 0.3,
                      delay: 300.ms,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 8),

                Text(
                  'Your campus. Your community. Your future.',
                  style: AppTypography.bodyMedium,
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                const SizedBox(height: 64),

                // Loading indicator
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary.withOpacity(0.7),
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
              ],
            ),
          ),

          // Bottom badge
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Text(
              'African Leadership University',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;
  const _Orb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
