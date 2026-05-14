import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/section_keys.dart';
import '../../../core/animations/animated_letter_reveal.dart';
import '../../../core/cursor/cursor_hover_region.dart';
import 'package:url_launcher/url_launcher.dart';

class NavbarSection extends StatefulWidget {
  final ScrollController scrollController;

  /// Hydration-aware navigation callback provided by PortfolioShell.
  /// Ensures the target section is hydrated before scrolling.
  final void Function(GlobalKey key) onNavigate;

  const NavbarSection({
    super.key,
    required this.scrollController,
    required this.onNavigate,
  });

  @override
  State<NavbarSection> createState() => _NavbarSectionState();
}

class _NavbarSectionState extends State<NavbarSection> {
  bool _hasScrolled = false;

  static const _scrollThreshold = 40.0;

  final _navItems = [
    ('work', 'Work', SectionKeys.projects),
    ('skills', 'Skills', SectionKeys.skills),
    ('about', 'About', SectionKeys.about),
    ('contact', 'Contact', SectionKeys.contact),
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    // Only rebuild when the binary state (scrolled vs not-scrolled) actually changes
    final scrolled = widget.scrollController.offset > _scrollThreshold;
    if (scrolled != _hasScrolled) {
      setState(() => _hasScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: _hasScrolled
            ? AppColors.bg.withValues(alpha: 0.85)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: _hasScrolled
                ? AppColors.border.withValues(alpha: 0.6)
                : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _hasScrolled
              ? ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Responsive.isMobile(context)
                        ? _buildMobileNav()
                        : _buildDesktopNav(),
                  ),
                )
              : (Responsive.isMobile(context)
                  ? _buildMobileNav()
                  : _buildDesktopNav()),
          // ── Scroll progress indicator (desktop only) ──
          if (!Responsive.isMobile(context))
            _ScrollProgressBar(scrollController: widget.scrollController),
        ],
      ),
    );
  }

  Widget _buildDesktopNav() {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Row(
          children: [
            // Logo wordmark
            GestureDetector(
              onTap: () => widget.onNavigate(SectionKeys.hero),
              child: CursorHoverRegion(
                child: MouseRegion(
                  child: _buildLogo(),
                ),
              ),
            ),
            const Spacer(),
            // Nav links
            ...(_navItems.map((item) => _NavLink(
                  label: item.$2,
                  onTap: () => widget.onNavigate(item.$3),
                ))),
            const SizedBox(width: AppSpacing.lg),
            const _GitHubLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNav() {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => widget.onNavigate(SectionKeys.hero),
              child: _buildLogo(),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _openMobileDrawer(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu_rounded,
                    color: AppColors.muted,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMobileDrawer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close menu',
      barrierColor: AppColors.bg.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutExpo);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.05),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return _MobileDrawerOverlay(
          navItems: _navItems,
          onItemTap: (key) {
            Navigator.of(context).pop();
            // Use hydration-aware navigation from the shell
            widget.onNavigate(key);
          },
        );
      },
    );
  }

  Widget _buildLogo() {
    return Text(
      'ibrahim.dev',
      style: AppTextStyles.mono.copyWith(
        color: AppColors.text,
        letterSpacing: 0.5,
        fontSize: 15,
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            style: AppTextStyles.nav.copyWith(
              color: _hovered ? AppColors.text : AppColors.muted,
            ),
            child: AnimatedLetterReveal(
              text: widget.label.toUpperCase(),
              staggerDelay: const Duration(milliseconds: 30),
            ),
          ),
        ),
      ),
    ));
  }
}

class _GitHubLink extends StatefulWidget {
  const _GitHubLink();

  @override
  State<_GitHubLink> createState() => _GitHubLinkState();
}

class _GitHubLinkState extends State<_GitHubLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('https://github.com/ibrahimelnahal20-lab');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.chips),
            border: Border.all(
              color: _hovered ? Colors.white.withValues(alpha: 0.2) : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.code_rounded,
                size: 16,
                color: _hovered ? AppColors.text : AppColors.muted,
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                style: AppTextStyles.nav.copyWith(
                  color: _hovered ? AppColors.text : AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
                child: const Text('GitHub'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class _MobileDrawerOverlay extends StatefulWidget {
  final List<(String, String, GlobalKey)> navItems;
  final void Function(GlobalKey key) onItemTap;

  const _MobileDrawerOverlay({
    required this.navItems,
    required this.onItemTap,
  });

  @override
  State<_MobileDrawerOverlay> createState() => _MobileDrawerOverlayState();
}

class _MobileDrawerOverlayState extends State<_MobileDrawerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ibrahim.dev',
                    style: AppTextStyles.mono.copyWith(
                      color: AppColors.muted2,
                      letterSpacing: 0.5,
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.muted, size: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl * 1.2),

              // ── Large typographic nav items ──
              ...List.generate(widget.navItems.length, (index) {
                final item = widget.navItems[index];
                final delay = index * 0.1;
                final animation = CurvedAnimation(
                  parent: _staggerController,
                  curve: Interval(
                    delay,
                    (delay + 0.5).clamp(0.0, 1.0),
                    curve: Curves.easeOutQuart,
                  ),
                );
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) => Opacity(
                    opacity: animation.value,
                    child: Transform.translate(
                      offset: Offset(0, 24 * (1 - animation.value)),
                      child: child,
                    ),
                  ),
                  child: _DrawerNavItem(
                    label: item.$2,
                    index: index + 1,
                    onTap: () => widget.onItemTap(item.$3),
                  ),
                );
              }),

              const Spacer(),

              // ── Bottom strip ──
              AnimatedBuilder(
                animation: CurvedAnimation(
                  parent: _staggerController,
                  curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                ),
                builder: (context, child) {
                  final val = CurvedAnimation(
                    parent: _staggerController,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  ).value;
                  return Opacity(opacity: val, child: child);
                },
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(
                            'https://github.com/ibrahimelnahal20-lab');
                        if (await canLaunchUrl(uri)) await launchUrl(uri);
                      },
                      child: Text('GITHUB ↗',
                          style: AppTextStyles.mono.copyWith(
                              color: AppColors.muted2,
                              letterSpacing: 2,
                              fontSize: 11)),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(
                            'mailto:ibrahimelnahal20@gmail.com');
                        if (await canLaunchUrl(uri)) await launchUrl(uri);
                      },
                      child: Text('EMAIL ↗',
                          style: AppTextStyles.mono.copyWith(
                              color: AppColors.muted2,
                              letterSpacing: 2,
                              fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

/// Large typographic nav item for mobile drawer.
class _DrawerNavItem extends StatefulWidget {
  final String label;
  final int index;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.label,
    required this.index,
    required this.onTap,
  });

  @override
  State<_DrawerNavItem> createState() => _DrawerNavItemState();
}

class _DrawerNavItemState extends State<_DrawerNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 250),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // Index number
              Text(
                '0${widget.index}',
                style: AppTextStyles.monoSmall.copyWith(
                  color: AppColors.muted2,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 14),
              // Label
              Text(
                widget.label.toUpperCase(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: 32,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 1px accent scroll-progress bar rendered below the desktop navbar.
/// Zero animation controllers — reads directly from ScrollController position.
class _ScrollProgressBar extends StatelessWidget {
  final ScrollController scrollController;
  const _ScrollProgressBar({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        double progress = 0.0;
        if (scrollController.hasClients) {
          final max = scrollController.position.maxScrollExtent;
          if (max > 0) {
            progress = (scrollController.offset / max).clamp(0.0, 1.0);
          }
        }
        return SizedBox(
          height: 1,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              color: AppColors.accent.withValues(alpha: 0.5),
            ),
          ),
        );
      },
    );
  }
}
