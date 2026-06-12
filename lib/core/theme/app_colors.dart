import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0B14);
  static const Color surface = Color(0xFF12141F);
  static const Color elevated = Color(0xFF1A1D2E);
  static const Color primary = Color(0xFFF5A623);
  static const Color secondary = Color(0xFF6C63FF);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8FA8);
  static const Color border = Color(0xFF1E2235);

  static const Color primaryLight = Color(0xFFF5A62326);
  static const Color secondaryLight = Color(0xFF6C63FF26);
  static const Color successLight = Color(0xFF2ECC7126);
  static const Color errorLight = Color(0xFFE74C3C26);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1D2E), Color(0xFF12141F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Colors.transparent, Color(0xDD0A0B14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
