// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/cursor/cursor_hover_region.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../data/models/project_model.dart';
import '../../../core/animations/animated_mask_reveal.dart';
import '../badges/status_badge.dart';
import '../chips/tech_chip.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;
  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  Widget build(BuildContext context) {
    return _isDesktop ? _buildDesktop() : _buildMobile();
  }

  // ── DESKTOP — full cinematic card (unchanged) ──
  Widget _buildDesktop() {
    final isFeatured = widget.project.isFeatured;
    final Matrix4 transform = _isHovered
        ? (Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-0.01)
          ..rotateY(0.01)
          ..translate(0.0, -8.0, 0.0))
        : Matrix4.identity();

    return CursorHoverRegion(
      mode: CursorHoverMode.card,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuart,
          transform: transform,
          padding: const EdgeInsets.all(AppSpacing.xl * 1.5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.cards),
            border: Border.all(
              color: _isHovered
                  ? (isFeatured
                      ? AppColors.accent.withValues(alpha: 0.6)
                      : AppColors.text.withValues(alpha: 0.2))
                  : AppColors.border,
              width: isFeatured ? 1.5 : 1.0,
            ),
            gradient: _isHovered
                ? LinearGradient(
                    colors: [
                      AppColors.surface,
                      isFeatured
                          ? AppColors.accent.withValues(alpha: 0.05)
                          : AppColors.text.withValues(alpha: 0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: isFeatured
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.4),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
            ],
          ),
          child: Stack(
            children: [
              if (isFeatured && _isHovered)
                Positioned(
                  right: -50,
                  top: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusBadge(
                          text: widget.project.badge,
                          type: widget.project.badgeType,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          widget.project.title,
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 32,
                            color: _isHovered
                                ? AppColors.text
                                : AppColors.muted2,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AnimatedMaskReveal(
                          delay: const Duration(milliseconds: 150),
                          child: Text(
                            widget.project.description,
                            style:
                                AppTextStyles.bodyLarge.copyWith(height: 1.8),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: widget.project.tags
                              .map((tag) => TechChip(
                                    label: tag,
                                    isHovered: _isHovered,
                                    accentColor: isFeatured
                                        ? AppColors.accent
                                        : AppColors.muted,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  if (isFeatured) ...[
                    const SizedBox(width: AppSpacing.xl),
                    _buildShowcaseIndicator(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowcaseIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart,
      transform: _isHovered
          ? Matrix4.translationValues(0, -4, 0)
          : Matrix4.identity(),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _isHovered
            ? AppColors.accent.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.buttons),
        border: Border.all(
          color: _isHovered ? AppColors.accent : AppColors.border,
        ),
      ),
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 500),
          scale: _isHovered ? 1.2 : 1.0,
          child: Icon(
            Icons.star_rounded,
            size: 24,
            color: _isHovered ? AppColors.accent : AppColors.muted,
          ),
        ),
      ),
    );
  }

  // ── MOBILE — premium mini case-study card ──
  Widget _buildMobile() => _MobileProjectCard(project: widget.project);
}

Future<void> _openUrl(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

class _MobileProjectCard extends StatefulWidget {
  final ProjectModel project;
  const _MobileProjectCard({required this.project});

  @override
  State<_MobileProjectCard> createState() => _MobileProjectCardState();
}

class _MobileProjectCardState extends State<_MobileProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 220),
      lowerBound: 0.98,
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
    final p = widget.project;
    final isFeatured = p.isFeatured;

    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) {
        _press.forward();
        if (p.projectUrl.isNotEmpty) {
          _openUrl(p.projectUrl);
        } else if (p.githubUrl.isNotEmpty) {
          _openUrl(p.githubUrl);
        }
      },
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _press,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.cards),
            border: Border.all(
              color: isFeatured
                  ? AppColors.accent.withValues(alpha: 0.25)
                  : AppColors.border,
              width: isFeatured ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header band ──
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: 12),
                decoration: BoxDecoration(
                  color: isFeatured
                      ? AppColors.accent.withValues(alpha: 0.04)
                      : AppColors.bg3,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.cards),
                    topRight: Radius.circular(AppRadius.cards),
                  ),
                ),
                child: Row(
                  children: [
                    StatusBadge(text: p.badge, type: p.badgeType),
                    const Spacer(),
                    if (p.githubUrl.isNotEmpty)
                      _TapTarget(
                        onTap: () => _openUrl(p.githubUrl),
                        child: const Icon(
                          Icons.code_rounded,
                          size: 18,
                          color: AppColors.muted2,
                        ),
                      ),
                    if (p.projectUrl.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      _TapTarget(
                        onTap: () => _openUrl(p.projectUrl),
                        child: const Icon(
                          Icons.open_in_new_rounded,
                          size: 18,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Body ──
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.description,
                      style: AppTextStyles.body.copyWith(
                        height: 1.6,
                        fontSize: 13.5,
                        color: AppColors.muted,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: p.tags
                          .map((tag) => _MobileProjectChip(
                                label: tag,
                                featured: isFeatured,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TapTarget extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _TapTarget({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(padding: const EdgeInsets.all(4), child: child),
    );
  }
}

class _MobileProjectChip extends StatelessWidget {
  final String label;
  final bool featured;
  const _MobileProjectChip({required this.label, required this.featured});

  @override
  Widget build(BuildContext context) {
    final color = featured ? AppColors.accent : AppColors.muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.18), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.monoSmall.copyWith(
          color: color.withValues(alpha: 0.8),
          fontSize: 11,
        ),
      ),
    );
  }
}
