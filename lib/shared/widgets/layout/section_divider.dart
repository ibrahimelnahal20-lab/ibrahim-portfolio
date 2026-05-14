import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'max_width_wrapper.dart';

/// A cinematic gradient-fade divider between sections.
/// Renders a line that fades in from transparent → border → transparent,
/// creating a subtle visual separation without hard edges.
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxWidthWrapper(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.border.withValues(alpha: 0.6),
              AppColors.border.withValues(alpha: 0.6),
              Colors.transparent,
            ],
            stops: const [0.0, 0.2, 0.8, 1.0],
          ),
        ),
      ),
    );
  }
}
