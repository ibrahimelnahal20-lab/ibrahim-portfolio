import 'package:flutter/material.dart';
import '../../../core/animations/reveal_animation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../shared/widgets/layout/section_container.dart';
import '../../../shared/widgets/layout/section_header.dart';
import '../../../core/animations/animated_mask_reveal.dart';
import '../../../core/cursor/cursor_hover_region.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RevealAnimation(
            delay: Duration(milliseconds: 100),
            child: SectionHeader(
              eyebrow: 'BACKGROUND',
              title: 'About Me',
              description: '',
              subtitle: 'A closer look at my professional journey and technical expertise.',
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (Responsive.isDesktop(context))
            const _DesktopLayout()
          else
            const _MobileLayout(),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IntroContent(),
                  SizedBox(height: AppSpacing.xxl),
                  _Timeline(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xxl * 1.5),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CategorizedSkills(),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      const Expanded(child: _Languages()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl * 1.5),
        const _TechStackShowcase(),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IntroContent(),
        SizedBox(height: AppSpacing.xl),
        _Timeline(),
        SizedBox(height: AppSpacing.xl),
        _CategorizedSkills(),
        SizedBox(height: AppSpacing.xl),
        _Languages(),
        SizedBox(height: AppSpacing.xl),
        _TechStackShowcase(),
      ],
    );
  }
}

class _IntroContent extends StatelessWidget {
  const _IntroContent();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedMaskReveal(
          delay: const Duration(milliseconds: 150),
          child: Text(
            isMobile
                ? 'Flutter & ASP.NET engineer specializing in Clean Architecture and MVVM. I build scalable, high-performance web and mobile experiences with a sharp focus on responsive UI systems.'
                : 'I am a serious frontend and full-stack engineer specializing in Flutter and ASP.NET. Driven by a passion for Clean Architecture and MVVM, I engineer scalable, high-performance web and mobile solutions with a strong focus on responsive UI systems.',
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.75,
              fontSize: isMobile ? 14.5 : null,
            ),
          ),
        ),
        if (!isMobile) ...
          [
            const SizedBox(height: AppSpacing.md),
            AnimatedMaskReveal(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Currently pursuing an Information Systems major at ASA Institute, I focus heavily on delivering end-to-end digital experiences. My core expertise lies in cross-platform development with Dart and state management using GetX and Provider, while seamlessly integrating robust SQL Server databases via RESTful APIs.\n\nAlways pushing to expand my technical horizon, I focus on clean UI/UX systems and responsive frontend engineering to ensure every application I build is technically sophisticated, highly scalable, and visually striking.',
                style: AppTextStyles.body.copyWith(height: 1.8),
              ),
            ),
          ],
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    return RevealAnimation(
      delay: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience & Education',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineItem(
                  year: 'January 2024 – Present',
                  title: 'Freelance Flutter Developer',
                  subtitle: 'Self-employed',
                  isLast: false,
                ),
                SizedBox(height: AppSpacing.xl),
                _TimelineItem(
                  year: '2023 – Present',
                  title: 'ASA Institute',
                  subtitle: 'Major in Information Systems',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String subtitle;
  final bool isLast;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.subtitle,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -25, // Align with the border
          top: 6,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.bg,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: AppColors.accent, width: 2),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: AppTextStyles.monoSmall.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategorizedSkills extends StatelessWidget {
  const _CategorizedSkills();

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Frontend', 'icon': Icons.phone_iphone, 'skills': 'Flutter, Dart, Flutter Web'},
      {'title': 'Backend', 'icon': Icons.dns, 'skills': 'ASP.NET, REST APIs'},
      {'title': 'Architecture', 'icon': Icons.architecture, 'skills': 'MVVM, Clean Architecture'},
      {'title': 'Databases', 'icon': Icons.data_usage, 'skills': 'SQL Server'},
      {'title': 'Tools', 'icon': Icons.build, 'skills': 'Git, VS Code, Android Studio'},
      {'title': 'UI/UX', 'icon': Icons.brush, 'skills': 'Figma, UI Systems'},
    ];

    return RevealAnimation(
      delay: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Technical Expertise', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.xl),
          if (Responsive.isMobile(context))
            // Mobile: Column with compact cards, no fixed-height grid
            Column(
              children: List.generate(categories.length, (index) {
                final cat = categories[index];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index < categories.length - 1 ? AppSpacing.sm : 0),
                  child: _CategoryCard(
                    title: cat['title'] as String,
                    skills: cat['skills'] as String,
                    icon: cat['icon'] as IconData,
                  ),
                );
              }),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                mainAxisExtent: 110,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return _CategoryCard(
                  title: cat['title'] as String,
                  skills: cat['skills'] as String,
                  icon: cat['icon'] as IconData,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String title;
  final String skills;
  final IconData icon;

  const _CategoryCard({
    required this.title,
    required this.skills,
    required this.icon,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      mode: CursorHoverMode.card,
      child: MouseRegion(
        onEnter: _isDesktop ? (_) => setState(() => _isHovered = true) : null,
        onExit: _isDesktop ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: _isHovered 
            ? Matrix4.translationValues(0.0, -4.0, 0.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.cards),
          border: Border.all(
            color: _isHovered ? AppColors.accent.withValues(alpha: 0.5) : AppColors.border,
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isHovered ? AppColors.accent.withValues(alpha: 0.15) : AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                scale: _isHovered ? 1.1 : 1.0,
                child: Icon(
                  widget.icon,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.skills,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.muted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _Languages extends StatelessWidget {
  const _Languages();

  @override
  Widget build(BuildContext context) {
    return RevealAnimation(
      delay: const Duration(milliseconds: 350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Languages', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.lg),
          // Full-width on mobile, wrapped on desktop
          Builder(builder: (context) {
            final isMobile = MediaQuery.sizeOf(context).width < 850;
            if (isMobile) {
              return Column(
                children: const [
                  _LanguageCard(language: 'Arabic', level: 'Native', progress: 1.0),
                  SizedBox(height: AppSpacing.sm),
                  _LanguageCard(language: 'English', level: 'B1', progress: 0.65),
                ],
              );
            }
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: const [
                SizedBox(
                  width: 200,
                  child: _LanguageCard(language: 'Arabic', level: 'Native', progress: 1.0),
                ),
                SizedBox(
                  width: 200,
                  child: _LanguageCard(language: 'English', level: 'B1', progress: 0.65),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final String language;
  final String level;
  final double progress;

  const _LanguageCard({
    required this.language,
    required this.level,
    required this.progress,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard> {
  bool _isHovered = false;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      mode: CursorHoverMode.card,
      child: MouseRegion(
        onEnter: _isDesktop ? (_) => setState(() => _isHovered = true) : null,
        onExit: _isDesktop ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: _isHovered 
            ? Matrix4.translationValues(0.0, -3.0, 0.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.cards),
          border: Border.all(
            color: _isHovered ? AppColors.accent.withValues(alpha: 0.5) : AppColors.border,
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: widget.progress),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutQuart,
                    builder: (context, value, _) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 2.5,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _isHovered ? AppColors.accent : AppColors.accent.withValues(alpha: 0.7),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Text(
                      '${(widget.progress * 100).toInt()}%',
                      style: AppTextStyles.monoSmall.copyWith(
                        fontSize: 10,
                        color: _isHovered ? AppColors.accent : AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.language,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.level,
                  style: AppTextStyles.monoSmall.copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class _TechStackShowcase extends StatelessWidget {
  const _TechStackShowcase();

  @override
  Widget build(BuildContext context) {
    final technologies = [
      {'label': 'Flutter', 'icon': Icons.flutter_dash},
      {'label': 'Dart', 'icon': Icons.code},
      {'label': 'ASP.NET', 'icon': Icons.language},
      {'label': 'SQL Server', 'icon': Icons.storage},
      {'label': 'GetX', 'icon': Icons.change_circle},
      {'label': 'Provider', 'icon': Icons.device_hub},
      {'label': 'MVVM', 'icon': Icons.architecture},
      {'label': 'Clean Arch.', 'icon': Icons.layers},
      {'label': 'Git', 'icon': Icons.merge_type},
      {'label': 'Figma', 'icon': Icons.design_services},
      {'label': 'REST API', 'icon': Icons.api},
    ];

    return RevealAnimation(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Core Technologies',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: technologies.map((tech) => _TechCard(
              label: tech['label'] as String,
              icon: tech['icon'] as IconData,
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _TechCard extends StatefulWidget {
  final String label;
  final IconData icon;

  const _TechCard({required this.label, required this.icon});

  @override
  State<_TechCard> createState() => _TechCardState();
}

class _TechCardState extends State<_TechCard> {
  bool _isHovered = false;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      mode: CursorHoverMode.card,
      child: MouseRegion(
        onEnter: _isDesktop ? (_) => setState(() => _isHovered = true) : null,
        onExit: _isDesktop ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: _isHovered 
            ? Matrix4.translationValues(0.0, -4.0, 0.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: _isHovered 
              ? LinearGradient(
                  colors: [
                    AppColors.surface,
                    AppColors.accent.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    AppColors.surface,
                    AppColors.surface,
                  ],
                ),
          borderRadius: BorderRadius.circular(AppRadius.chips),
          border: Border.all(
            color: _isHovered ? AppColors.accent.withValues(alpha: 0.8) : AppColors.border,
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              scale: _isHovered ? 1.1 : 1.0,
              child: Icon(
                widget.icon,
                size: 18,
                color: _isHovered ? AppColors.accent : AppColors.muted,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              style: AppTextStyles.bodyLarge.copyWith(
                color: _isHovered ? AppColors.accent : AppColors.text,
                fontWeight: FontWeight.bold,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    ));
  }
}
