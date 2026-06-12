import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool showOnlineIndicator;
  final bool isOnline;
  final Color? borderColor;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 2)
                : null,
            color: AppColors.elevated,
          ),
          child: ClipOval(
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _buildPlaceholder(),
                    errorWidget: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
        ),
        if (showOnlineIndicator)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: isOnline ? AppColors.success : AppColors.textSecondary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    final initials = name != null && name!.isNotEmpty
        ? name!.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';
    return Container(
      color: AppColors.elevated,
      child: Center(
        child: Text(
          initials,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: size * 0.32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AvatarStack extends StatelessWidget {
  final List<String> avatarUrls;
  final double size;
  final int maxVisible;

  const AvatarStack({
    super.key,
    required this.avatarUrls,
    this.size = 28,
    this.maxVisible = 4,
  });

  @override
  Widget build(BuildContext context) {
    final visible = avatarUrls.take(maxVisible).toList();
    final extra = avatarUrls.length - visible.length;

    return SizedBox(
      height: size,
      width: (visible.length + (extra > 0 ? 1 : 0)) * (size * 0.7) + size * 0.3,
      child: Stack(
        children: [
          ...visible.asMap().entries.map((entry) {
            return Positioned(
              left: entry.key * (size * 0.7),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
                padding: const EdgeInsets.all(1.5),
                child: UserAvatar(imageUrl: entry.value, size: size),
              ),
            );
          }),
          if (extra > 0)
            Positioned(
              left: visible.length * (size * 0.7),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.elevated,
                  border: Border.all(color: AppColors.background, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: size * 0.3,
                      fontWeight: FontWeight.w600,
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
