// App-wide constants for spacing, radii, durations, and category metadata.
import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0A0B14);
  static const surface = Color(0xFF12141F);
  static const elevated = Color(0xFF1A1D2E);
  static const primary = Color(0xFFF5A623);
  static const secondary = Color(0xFF6C63FF);
  static const success = Color(0xFF2ECC71);
  static const error = Color(0xFFE74C3C);
  static const neutralTag = Color(0xFF2A2D3E);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A8FA8);
  static const border = Color(0xFF1E2235);
  static const sentBubble = Color(0xFF2A2200);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

class AppRadius {
  static const card = 16.0;
  static const button = 12.0;
  static const bottomSheet = 24.0;
  static const chip = 20.0;
  static const avatar = 100.0;
}

class AppDuration {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
}

class AppIconSize {
  static const nav = 20.0;
  static const inline = 18.0;
  static const standalone = 24.0;
}

// Category color map used across event/opportunity cards.
const Map<String, Color> kCategoryColors = {
  'Startup': Color(0xFFF5A623),
  'Workshop': Color(0xFF6C63FF),
  'Leadership': Color(0xFF2ECC71),
  'Community': Color(0xFF3BAFDA),
  'Academic': Color(0xFFE74C3C),
  'Social': Color(0xFFFF6B9D),
  'Tech': Color(0xFF00BCD4),
  'Competition': Color(0xFFFF9800),
};

const kCampuses = ['Kigali', 'Mauritius', 'Both'];

const kCategories = [
  'Workshop',
  'Hackathon',
  'Leadership',
  'Community',
  'Academic',
  'Startup',
  'Social',
];
