// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class TechChip extends StatelessWidget {
  final String label;
  final bool isHovered;
  final Color? accentColor;

  const TechChip({
    super.key, 
    required this.label,
    this.isHovered = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isHovered 
            ? (accentColor?.withValues(alpha: 0.1) ?? AppColors.accent.withValues(alpha: 0.1))
            : AppColors.surface,
        border: Border.all(
          color: isHovered 
              ? (accentColor?.withValues(alpha: 0.4) ?? AppColors.accent.withValues(alpha: 0.4))
              : AppColors.border,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(AppRadius.chips),
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 400),
        style: AppTextStyles.chip.copyWith(
          color: isHovered 
              ? (accentColor ?? AppColors.accent)
              : AppColors.muted,
        ),
        child: Text(label),
      ),
    );
  }
}
