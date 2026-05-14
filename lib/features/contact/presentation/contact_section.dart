import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/animations/reveal_animation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/layout/section_container.dart';
import '../../../core/animations/animated_letter_reveal.dart';
import '../../../core/animations/animated_mask_reveal.dart';
import '../../../core/utils/platform_utils.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;
    return isMobile ? const _ContactMobile() : const _ContactDesktop();
  }
}

// ──────────────────────────────────────────────
// DESKTOP — unchanged centered layout
// ──────────────────────────────────────────────

class _ContactDesktop extends StatelessWidget {
  const _ContactDesktop();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -100,
                child: RevealAnimation(
                  delay: const Duration(milliseconds: 800),
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  AnimatedLetterReveal(
                    delay: const Duration(milliseconds: 50),
                    text: "LET'S BUILD SOMETHING",
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.accent,
                      letterSpacing: 4,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedMaskReveal(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'Get In Touch',
                      style: AppTextStyles.h2.copyWith(fontSize: 48),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AnimatedMaskReveal(
                    delay: const Duration(milliseconds: 150),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        "Whether you need a full-scale web application, a robust mobile app, or a technical consultation, I'm ready to engineer it. Let's create something exceptional together.",
                        style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl * 1.5),
                  const RevealAnimation(
                    delay: Duration(milliseconds: 250),
                    child: _DesktopContactCards(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopContactCards extends StatelessWidget {
  const _DesktopContactCards();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ContactCard(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: 'ibrahimelnahal20@gmail.com',
          url: 'mailto:ibrahimelnahal20@gmail.com',
        ),
        SizedBox(height: AppSpacing.lg),
        _ContactCard(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: '+20 127 336 8009',
          url: 'tel:+201273368009',
        ),
        SizedBox(height: AppSpacing.lg),
        _ContactCard(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: 'github.com/ibrahimelnahal20-lab',
          url: 'https://github.com/ibrahimelnahal20-lab',
        ),
        SizedBox(height: AppSpacing.lg),
        _ContactCard(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: '10th of Ramadan, Egypt',
          url: '',
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// MOBILE — premium focused, action-oriented
// ──────────────────────────────────────────────

class _ContactMobile extends StatelessWidget {
  const _ContactMobile();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Eyebrow ──
          AnimatedLetterReveal(
            delay: const Duration(milliseconds: 50),
            text: "LET'S BUILD SOMETHING",
            style: AppTextStyles.eyebrow.copyWith(
              color: AppColors.accent,
              letterSpacing: 3,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 10),

          // ── Heading ──
          AnimatedMaskReveal(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Get In Touch',
              style: AppTextStyles.h2.copyWith(
                fontSize: 28,
                letterSpacing: -1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Tagline ──
          AnimatedMaskReveal(
            delay: const Duration(milliseconds: 150),
            child: Text(
              "Ready to engineer something exceptional together.",
              style: AppTextStyles.body.copyWith(
                height: 1.65,
                fontSize: 14,
                color: AppColors.muted,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Primary email CTA ──
          RevealAnimation(
            delay: const Duration(milliseconds: 220),
            type: RevealType.up,
            child: _MobilePrimaryContact(
              icon: Icons.mail_outline_rounded,
              label: 'Email',
              value: 'ibrahimelnahal20@gmail.com',
              url: 'mailto:ibrahimelnahal20@gmail.com',
              isPrimary: true,
            ),
          ),

          const SizedBox(height: 12),

          // ── Secondary contacts: 2-column row ──
          RevealAnimation(
            delay: const Duration(milliseconds: 300),
            type: RevealType.fade,
            child: Row(
              children: const [
                Expanded(
                  child: _MobileContactTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: '+20 127 336 8009',
                    url: 'tel:+201273368009',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MobileContactTile(
                    icon: Icons.code_rounded,
                    label: 'GitHub',
                    value: 'ibrahimelnahal20-lab',
                    url: 'https://github.com/ibrahimelnahal20-lab',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Location chip ──
          RevealAnimation(
            delay: const Duration(milliseconds: 360),
            type: RevealType.fade,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.bg3,
                borderRadius: BorderRadius.circular(AppRadius.cards),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: AppColors.muted2,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '10th of Ramadan, Egypt',
                    style: AppTextStyles.monoSmall.copyWith(
                      color: AppColors.muted2,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width primary contact row — email hero CTA.
class _MobilePrimaryContact extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;
  final bool isPrimary;

  const _MobilePrimaryContact({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.isPrimary,
  });

  @override
  State<_MobilePrimaryContact> createState() => _MobilePrimaryContactState();
}

class _MobilePrimaryContactState extends State<_MobilePrimaryContact>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 220),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Future<void> _launch() async {
    if (widget.url.isEmpty) return;
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) {
        _press.forward();
        _launch();
      },
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _press,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.cards),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.mail_outline_rounded,
                    size: 22,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label.toUpperCase(),
                      style: AppTextStyles.monoSmall.copyWith(
                        color: AppColors.accent,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.value,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_outward_rounded,
                size: 18,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact 2-column contact tile.
class _MobileContactTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;

  const _MobileContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  @override
  State<_MobileContactTile> createState() => _MobileContactTileState();
}

class _MobileContactTileState extends State<_MobileContactTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 220),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Future<void> _launch() async {
    if (widget.url.isEmpty) return;
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) {
        _press.forward();
        _launch();
      },
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _press,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.cards),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.icon, size: 16, color: AppColors.muted2),
                  const SizedBox(width: 6),
                  Text(
                    widget.label.toUpperCase(),
                    style: AppTextStyles.monoSmall.copyWith(
                      color: AppColors.muted2,
                      letterSpacing: 1.5,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                widget.value,
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shared desktop contact card (unchanged from original ContactLinkCard behavior).
class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;
  static final bool _isDesktop = PlatformUtils.isDesktop;

  Future<void> _launch() async {
    if (widget.url.isEmpty) return;
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.url.isNotEmpty;
    final showHover = _hovered && isClickable;

    return MouseRegion(
      onEnter: _isDesktop ? (_) => setState(() => _hovered = true) : null,
      onExit: _isDesktop ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: isClickable ? _launch : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: showHover
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
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
                ),
            ],
          ),
          child: Row(
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
                    color: showHover ? AppColors.accent : AppColors.muted,
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
                        color: showHover ? AppColors.accent : AppColors.muted2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      style: AppTextStyles.h3.copyWith(
                        color: showHover ? AppColors.text : AppColors.muted,
                        fontSize: 20,
                      ),
                      child: Text(widget.value),
                    ),
                  ],
                ),
              ),
              if (isClickable)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: showHover ? 1.0 : 0.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    transform: showHover
                        ? Matrix4.translationValues(4, -4, 0)
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
    );
  }
}
