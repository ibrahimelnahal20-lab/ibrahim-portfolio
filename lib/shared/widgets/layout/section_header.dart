import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/animations/animated_word_reveal.dart';
import '../../../core/animations/animated_letter_reveal.dart';
import '../../../core/animations/animated_mask_reveal.dart';

class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required String description,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    final isMobile = sw < 850;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow
        AnimatedLetterReveal(
          text: eyebrow.toUpperCase(),
          style: AppTextStyles.eyebrow.copyWith(
            fontSize: isMobile ? 10 : null,
            letterSpacing: isMobile ? 2.5 : null,
          ),
        ),
        SizedBox(height: isMobile ? 10 : AppSpacing.sm),

        // Section title
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: AnimatedWordReveal(
            text: title,
            style: isMobile
                ? AppTextStyles.h2.copyWith(
                    fontSize: 26,
                    letterSpacing: -1.0,
                    height: 1.15,
                  )
                : AppTextStyles.h2,
            delay: const Duration(milliseconds: 100),
          ),
        ),
        SizedBox(height: isMobile ? 10 : AppSpacing.md),

        // Subtitle
        AnimatedMaskReveal(
          delay: const Duration(milliseconds: 200),
          child: Text(
            subtitle,
            style: AppTextStyles.body.copyWith(
              fontSize: isMobile ? 14 : null,
              height: isMobile ? 1.65 : 1.7,
              color: null, // inherits muted from body style
            ),
          ),
        ),
      ],
    );
  }
}
