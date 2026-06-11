// Colored circle showing user initials — used throughout the app.
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import 'shimmer_box.dart';

class AvatarCircle extends StatelessWidget {
  final String initials;
  final double size;
  final Color? color;
  final double fontSize;
  final String? imageUrl;

  const AvatarCircle({
    super.key,
    required this.initials,
    this.size = 40,
    this.color,
    this.fontSize = 14,
    this.imageUrl,
  });

  static Color _colorFromInitials(String initials) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      const Color(0xFF2ECC71),
      const Color(0xFF3BAFDA),
      const Color(0xFFFF6B9D),
      const Color(0xFFE74C3C),
    ];
    final idx = initials.isNotEmpty ? initials.codeUnitAt(0) % colors.length : 0;
    return colors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final bg = color ?? _colorFromInitials(initials);
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerBox(width: size, height: size, borderRadius: size / 2),
          errorWidget: (context, url, error) => _buildFallback(bg),
        ),
      );
    }
    return _buildFallback(bg);
  }

  Widget _buildFallback(Color bg) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bg, bg.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials.length > 2 ? initials.substring(0, 2) : initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
