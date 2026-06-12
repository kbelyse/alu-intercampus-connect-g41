import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    this.hintText = 'Search events, communities...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly ? onTap : null,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: readOnly
                  ? Text(hintText, style: AppTypography.bodyMedium)
                  : TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: AppTypography.bodyMedium,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
