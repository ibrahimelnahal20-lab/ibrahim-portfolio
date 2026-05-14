import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_effects.dart';
import '../../../core/cursor/cursor_hover_region.dart';

class OutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const OutlineButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppEffects.hoverDuration,
          curve: AppEffects.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: _isHovered ? AppColors.text : AppColors.border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.buttons),
          ),
          child: AnimatedDefaultTextStyle(
            duration: AppEffects.hoverDuration,
            curve: AppEffects.easeOut,
            style: AppTextStyles.button.copyWith(
              color: _isHovered ? AppColors.text : AppColors.muted,
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    ));
  }
}
