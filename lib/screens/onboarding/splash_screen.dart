// Animated splash and onboarding screen with ALU branding.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../widgets/common/shimmer_box.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Full-bleed hero image at top
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=800&q=80',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerBox(
                    width: double.infinity,
                    height: 280,
                    borderRadius: 0,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                // Dark gradient overlay bottom 60%
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.background,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
                // ALU logo/title/tagline over the gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.lg),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Column(
                            children: [
                              _AluLogo(),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                'ALU Intercampus\nConnect',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.spaceGrotesk(
                                  color: AppColors.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              const Text(
                                'Connect. Collaborate. Lead together.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Buttons section
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      const Spacer(),
                      // Primary CTA
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.lg),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.chip),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Continue with ALU Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // OAuth row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go('/home'),
                              icon: const Icon(Icons.g_mobiledata,
                                  color: AppColors.textPrimary, size: 20),
                              label: const Text(
                                'Google',
                                style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md),
                                side: const BorderSide(
                                    color: AppColors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppRadius.button),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go('/home'),
                              icon: const Icon(Icons.apple,
                                  color: AppColors.textPrimary, size: 20),
                              label: const Text(
                                'Apple',
                                style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md),
                                side: const BorderSide(
                                    color: AppColors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppRadius.button),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      GestureDetector(
                        onTap: () => context.go('/home'),
                        child: const Text(
                          'New here? Create account',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Geometric ALU triangle logo drawn with CustomPaint.
class _AluLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(80, 80),
      painter: _TrianglePainter(),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final innerPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;

    // Outer triangle
    final outer = Path()
      ..moveTo(cx, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(outer, outerPaint);

    // Inner cut triangle
    final inner = Path()
      ..moveTo(cx, size.height * 0.25)
      ..lineTo(size.width * 0.75, size.height * 0.78)
      ..lineTo(size.width * 0.25, size.height * 0.78)
      ..close();
    canvas.drawPath(inner, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
