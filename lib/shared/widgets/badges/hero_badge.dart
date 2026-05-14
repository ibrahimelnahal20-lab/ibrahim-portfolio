// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/animations/animated_letter_reveal.dart';
import '../../../core/utils/platform_utils.dart';

class HeroBadge extends StatefulWidget {
  const HeroBadge({super.key});

  @override
  State<HeroBadge> createState() => _HeroBadgeState();
}

class _HeroBadgeState extends State<HeroBadge>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _pulseAnimation;
  Animation<Offset>? _floatAnimation;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  void initState() {
    super.initState();
    if (_isDesktop) {
      // Desktop: full pulse + float animation
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat(reverse: true);

      _pulseAnimation = Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));

      _floatAnimation = Tween<Offset>(
        begin: const Offset(0, -2),
        end: const Offset(0, 2),
      ).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOutSine),
      );
    }
    // Mobile: no animation controller at all — zero continuous GPU work
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Mobile: fully static badge (no animation controller, no tickers) ──
    if (!_isDesktop) {
      return _buildBadge(pulseOpacity: 0.8);
    }

    // ── Desktop: floating badge with pulsing dot ──
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Transform.translate(
          offset: _floatAnimation!.value,
          child: child,
        );
      },
      child: _buildBadge(),
    );
  }

  Widget _buildBadge({double? pulseOpacity}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulseOpacity != null)
            // Static dot on mobile
            Opacity(
              opacity: pulseOpacity,
              child: _buildDot(),
            )
          else
            // Animated pulse on desktop
            FadeTransition(
              opacity: _pulseAnimation!,
              child: _buildDot(),
            ),
          const SizedBox(width: AppSpacing.sm),
          AnimatedLetterReveal(
            text: 'Available for work',
            style: AppTextStyles.monoSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: AppColors.accent, blurRadius: 4),
        ],
      ),
    );
  }
}
