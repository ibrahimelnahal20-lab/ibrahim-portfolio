import 'package:flutter/material.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../core/animations/reveal_animation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/section_keys.dart';
import '../../../shared/widgets/badges/hero_badge.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/cards/code_card.dart';
import '../../../core/animations/animated_word_reveal.dart';
import '../../../core/animations/animated_mask_reveal.dart';
import '../../../core/cursor/cursor_hover_region.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  /// Hydration-aware navigation — passed from PortfolioShell.
  final void Function(GlobalKey)? onNavigate;

  const HeroSection({super.key, this.onNavigate});

  void _scrollTo(GlobalKey key) {
    if (onNavigate != null) {
      onNavigate!(key);
    } else if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutQuart,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? _HeroMobile(onNavigate: _scrollTo)
        : _HeroDesktop(onNavigate: _scrollTo);
  }
}

// ─────────────────────────────────────────────
// DESKTOP — unchanged cinematic experience
// ─────────────────────────────────────────────

class _HeroDesktop extends StatefulWidget {
  final void Function(GlobalKey) onNavigate;
  const _HeroDesktop({required this.onNavigate});

  @override
  State<_HeroDesktop> createState() => _HeroDesktopState();
}

class _HeroDesktopState extends State<_HeroDesktop>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        setState(() {
          final size = MediaQuery.of(context).size;
          _mousePos = Offset(
            (e.position.dx / size.width) * 2 - 1,
            (e.position.dy / size.height) * 2 - 1,
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 200.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -100,
              top: 50,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(
                        0,
                        Curves.easeInOutSine
                                .transform(_floatController.value) *
                            20),
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.translationValues(
                        _mousePos.dx * -15, _mousePos.dy * -15, 0),
                    child: _buildLeftColumn(),
                  ),
                ),
                const SizedBox(width: AppSpacing.xxl * 2),
                Expanded(
                  flex: 6,
                  child: RevealAnimation(
                    delay: const Duration(milliseconds: 800),
                    child: AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        final floatY =
                            Curves.easeInOutSine.transform(_floatController.value) *
                                12 -
                            6;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          transform: Matrix4.translationValues(
                              _mousePos.dx * 25,
                              _mousePos.dy * 25 + floatY,
                              0),
                          child: child,
                        );
                      },
                      child: const CodeCard(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RevealAnimation(
          delay: Duration(milliseconds: 100),
          child: HeroBadge(),
        ),
        const SizedBox(height: AppSpacing.xxl),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: AnimatedWordReveal(
            text: 'Ibrahim',
            delay: const Duration(milliseconds: 300),
            style: AppTextStyles.h1.copyWith(
              fontSize: 84,
              fontWeight: FontWeight.w900,
              letterSpacing: -2.0,
              height: 0.95,
              color: AppColors.text,
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: AnimatedWordReveal(
            text: 'Elnahal',
            delay: const Duration(milliseconds: 400),
            style: AppTextStyles.h1.copyWith(
              fontSize: 84,
              fontWeight: FontWeight.w900,
              letterSpacing: -2.0,
              height: 0.95,
              color: AppColors.muted2,
            ),
          ),
        ),
        AnimatedMaskReveal(
          delay: const Duration(milliseconds: 450),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: _AnimatedStrokeText(
              text: 'Developer.',
              style: AppTextStyles.heroOutline.copyWith(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                letterSpacing: -3.0,
                height: 0.95,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AnimatedMaskReveal(
          delay: const Duration(milliseconds: 600),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              'A dedicated Flutter engineer crafting high-performance, cinematic web and mobile solutions. Focused on clean architecture, beautiful UIs, and premium frontend experiences.',
              style: AppTextStyles.bodyLarge.copyWith(
                height: 1.8,
                color: AppColors.muted,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl * 1.5),
        RevealAnimation(
          delay: const Duration(milliseconds: 700),
          child: Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            children: [
              PrimaryButton(
                text: 'View Projects',
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.bg, size: 20),
                onTap: () => widget.onNavigate(SectionKeys.projects),
              ),
              OutlineButton(
                text: 'Get in touch',
                onTap: () => widget.onNavigate(SectionKeys.contact),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const RevealAnimation(
          delay: Duration(milliseconds: 600),
          child: _HeroSocialRow(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MOBILE — premium cinematic redesign
// ─────────────────────────────────────────────

class _HeroMobile extends StatelessWidget {
  final void Function(GlobalKey) onNavigate;
  const _HeroMobile({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    final isSmall = sw < 380;

    // Responsive type scale
    final double nameFontSize = isSmall ? 44 : (sw < 420 ? 50 : 56);
    final double outlineFontSize = isSmall ? 48 : (sw < 420 ? 54 : 60);
    final double bodyFontSize = isSmall ? 14.0 : 15.0;

    return Padding(
      padding: EdgeInsets.only(
        top: isSmall ? 32 : 40,
        bottom: 56,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Availability badge + role tag inline ──
          RevealAnimation(
            delay: const Duration(milliseconds: 80),
            type: RevealType.fade,
            child: Row(
              children: [
                const HeroBadge(),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.bg3,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Flutter · ASP.NET',
                    style: AppTextStyles.monoSmall.copyWith(
                      color: AppColors.muted2,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmall ? 24 : 28),

          // ── 2. Name block — tight cinematic stagger ──
          AnimatedWordReveal(
            text: 'Ibrahim',
            delay: const Duration(milliseconds: 200),
            style: AppTextStyles.h1.copyWith(
              fontSize: nameFontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: AppColors.text,
            ),
          ),
          AnimatedWordReveal(
            text: 'Elnahal',
            delay: const Duration(milliseconds: 290),
            style: AppTextStyles.h1.copyWith(
              fontSize: nameFontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: AppColors.muted2,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedMaskReveal(
            delay: const Duration(milliseconds: 360),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: _AnimatedStrokeText(
                text: 'Developer.',
                style: AppTextStyles.heroOutline.copyWith(
                  fontSize: outlineFontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2.0,
                  height: 1.05,
                ),
              ),
            ),
          ),

          SizedBox(height: isSmall ? 20 : 24),

          // ── 3. Tagline — crisp, single paragraph ──
          AnimatedMaskReveal(
            delay: const Duration(milliseconds: 440),
            child: Text(
              'Flutter engineer building high-performance web & mobile experiences. Clean architecture, cinematic UI.',
              style: AppTextStyles.body.copyWith(
                height: 1.7,
                color: AppColors.muted,
                fontSize: bodyFontSize,
              ),
            ),
          ),

          SizedBox(height: isSmall ? 28 : 32),

          // ── 4. CTA row — primary fills, secondary ghost ──
          RevealAnimation(
            delay: const Duration(milliseconds: 520),
            type: RevealType.up,
            child: Row(
              children: [
                Expanded(
                  child: _MobilePrimaryButton(
                    label: 'View Projects',
                    onTap: () => onNavigate(SectionKeys.projects),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MobileOutlineButton(
                    label: 'Get in touch',
                    onTap: () => onNavigate(SectionKeys.contact),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmall ? 28 : 32),

          // ── 5. Social + metadata strip ──
          RevealAnimation(
            delay: const Duration(milliseconds: 580),
            type: RevealType.fade,
            child: const _MobileMetaStrip(),
          ),

          SizedBox(height: isSmall ? 36 : 44),

          // ── 6. Code card — compact mobile variant ──
          RevealAnimation(
            delay: const Duration(milliseconds: 640),
            type: RevealType.up,
            child: const CodeCard(mobileCompact: true),
          ),
        ],
      ),
    );
  }
}

/// Compact full-width primary button for mobile.
class _MobilePrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _MobilePrimaryButton({required this.label, required this.onTap});

  @override
  State<_MobilePrimaryButton> createState() => _MobilePrimaryButtonState();
}

class _MobilePrimaryButtonState extends State<_MobilePrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) {
        _press.forward();
        widget.onTap();
      },
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _press,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(AppRadius.buttons),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.button.copyWith(
                  color: AppColors.bg,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_rounded,
                  color: AppColors.bg, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ghost outline button for mobile.
class _MobileOutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _MobileOutlineButton({required this.label, required this.onTap});

  @override
  State<_MobileOutlineButton> createState() => _MobileOutlineButtonState();
}

class _MobileOutlineButtonState extends State<_MobileOutlineButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) {
        _press.forward();
        widget.onTap();
      },
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _press,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.buttons),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: AppTextStyles.button.copyWith(
                color: AppColors.muted,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal metadata strip: socials + location tag.
class _MobileMetaStrip extends StatelessWidget {
  const _MobileMetaStrip();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Social buttons
        _MobileSocialIcon(
          icon: Icons.code_rounded,
          label: 'GitHub',
          onTap: () async {
            final uri = Uri.parse('https://github.com/ibrahimelnahal20-lab');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        const SizedBox(width: 10),
        _MobileSocialIcon(
          icon: Icons.alternate_email_rounded,
          label: 'Email',
          onTap: () async {
            final uri = Uri.parse('mailto:ibrahimelnahal20@gmail.com');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        const SizedBox(width: 16),
        // Vertical divider
        Container(width: 1, height: 20, color: AppColors.border),
        const SizedBox(width: 16),
        // Location tag
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 13, color: AppColors.muted2),
            const SizedBox(width: 4),
            Text(
              'Egypt · Remote',
              style: AppTextStyles.monoSmall.copyWith(
                color: AppColors.muted2,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileSocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MobileSocialIcon(
      {required this.icon, required this.label, required this.onTap});

  @override
  State<_MobileSocialIcon> createState() => _MobileSocialIconState();
}

class _MobileSocialIconState extends State<_MobileSocialIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) {
        _press.forward();
        widget.onTap();
      },
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _press,
        child: Tooltip(
          message: widget.label,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Icon(widget.icon, size: 18, color: AppColors.muted),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED — stroke text, social row
// ─────────────────────────────────────────────

class _AnimatedStrokeText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _AnimatedStrokeText({required this.text, required this.style});

  @override
  State<_AnimatedStrokeText> createState() => _AnimatedStrokeTextState();
}

class _AnimatedStrokeTextState extends State<_AnimatedStrokeText>
    with SingleTickerProviderStateMixin {
  AnimationController? _gradientController;

  @override
  void initState() {
    super.initState();
    if (PlatformUtils.isDesktop) {
      _gradientController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _gradientController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isMobile) {
      return Stack(
        children: [
          Text(widget.text,
              style: widget.style
                  .copyWith(color: AppColors.accent.withValues(alpha: 0.05))),
          Text(
            widget.text,
            style: widget.style.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.8
                ..color = AppColors.accent.withValues(alpha: 0.55),
            ),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _gradientController!,
      builder: (context, child) {
        return Stack(
          children: [
            Text(widget.text,
                style: widget.style
                    .copyWith(color: AppColors.accent.withValues(alpha: 0.05))),
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    AppColors.text.withValues(alpha: 0.2),
                    AppColors.accent.withValues(alpha: 1.0),
                    Colors.white,
                    AppColors.text.withValues(alpha: 0.2),
                  ],
                  stops: const [0.0, 0.4, 0.6, 1.0],
                  begin: Alignment(-2.0 + (_gradientController!.value * 3), 0),
                  end: Alignment(0.0 + (_gradientController!.value * 3), 0),
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                style: widget.style.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2.5
                    ..color = Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeroSocialRow extends StatelessWidget {
  const _HeroSocialRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIconButton(
          icon: Icons.code_rounded,
          tooltip: 'GitHub',
          onTap: () async {
            final uri = Uri.parse('https://github.com/ibrahimelnahal20-lab');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        const SizedBox(width: AppSpacing.md),
        _SocialIconButton(
          icon: Icons.alternate_email_rounded,
          tooltip: 'Email',
          onTap: () async {
            final uri = Uri.parse('mailto:ibrahimelnahal20@gmail.com');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIconButton(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;
  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      mode: CursorHoverMode.accent,
      child: MouseRegion(
        onEnter: _isDesktop ? (_) => setState(() => _isHovered = true) : null,
        onExit: _isDesktop ? (_) => setState(() => _isHovered = false) : null,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Tooltip(
            message: widget.tooltip,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.border),
            ),
            textStyle:
                AppTextStyles.monoSmall.copyWith(color: AppColors.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:
                    _isHovered ? AppColors.surface : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isHovered
                      ? AppColors.accent.withValues(alpha: 0.5)
                      : AppColors.border,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: _isHovered ? 1.1 : 1.0,
                  child: Icon(widget.icon,
                      size: 20,
                      color: _isHovered
                          ? AppColors.accent
                          : AppColors.muted),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
