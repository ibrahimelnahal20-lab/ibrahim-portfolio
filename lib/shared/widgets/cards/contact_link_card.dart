import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/cursor/cursor_hover_region.dart';
import '../../../core/utils/platform_utils.dart';

class ContactLinkCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;

  const ContactLinkCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  @override
  State<ContactLinkCard> createState() => _ContactLinkCardState();
}

class _ContactLinkCardState extends State<ContactLinkCard> {
  bool _hovered = false;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  Future<void> _launchUrl() async {
    if (widget.url.isEmpty) return;
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isClickable = widget.url.isNotEmpty;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isNarrow = screenWidth < 850;

    // On mobile, _hovered is always false — touch doesn't hover.
    // This avoids allocating hover-state gradients, shadows, and transforms.
    final bool showHover = _hovered && isClickable;

    return CursorHoverRegion(
      enabled: isClickable,
      mode: CursorHoverMode.card,
      child: MouseRegion(
        onEnter: _isDesktop ? (_) => setState(() => _hovered = true) : null,
        onExit: _isDesktop ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: isClickable ? _launchUrl : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: showHover
              ? Matrix4.translationValues(0.0, -4.0, 0.0)
              : Matrix4.identity(),
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? AppSpacing.lg : AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.cards),
            border: Border.all(
              color: showHover
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : AppColors.border,
              width: 1.5,
            ),
            gradient: showHover
                ? LinearGradient(
                    colors: [
                      AppColors.surface,
                      AppColors.accent.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: [
              if (showHover)
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: showHover
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : AppColors.accent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  scale: showHover ? 1.15 : 1.0,
                  child: Icon(
                    widget.icon,
                    size: 24,
                    color: showHover
                        ? AppColors.accent
                        : AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label.toUpperCase(),
                      style: AppTextStyles.monoSmall.copyWith(
                        letterSpacing: 2.0,
                        color: showHover
                            ? AppColors.accent
                            : AppColors.muted2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      style: AppTextStyles.h3.copyWith(
                        color: showHover
                            ? AppColors.text
                            : AppColors.muted,
                        fontSize: isNarrow ? 16 : 20,
                      ),
                      child: Text(widget.value),
                    ),
                  ],
                ),
              ),
              if (isClickable)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isNarrow ? 0.5 : (showHover ? 1.0 : 0.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    transform: showHover 
                        ? Matrix4.translationValues(4.0, -4.0, 0.0)
                        : Matrix4.identity(),
                    child: const Icon(
                      Icons.arrow_outward,
                      color: AppColors.accent,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }
}
