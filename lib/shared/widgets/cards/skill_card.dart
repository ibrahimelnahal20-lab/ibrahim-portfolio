// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/cursor/cursor_hover_region.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../data/models/skill_model.dart';
import '../chips/tech_chip.dart';

class SkillCard extends StatefulWidget {
  final SkillModel skill;

  const SkillCard({super.key, required this.skill});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  AnimationController? _pulseController;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  void initState() {
    super.initState();
    if (_isDesktop) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isDesktop ? _buildDesktop() : _buildMobile();
  }

  // ── DESKTOP — full hover cinematic experience ──
  Widget _buildDesktop() {
    return CursorHoverRegion(
      mode: CursorHoverMode.card,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -6.0, 0.0))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.cards),
            border: Border.all(
              color: _isHovered
                  ? widget.skill.accentColor.withValues(alpha: 0.6)
                  : AppColors.border,
              width: 1.5,
            ),
            gradient: _isHovered
                ? LinearGradient(
                    colors: [
                      AppColors.surface,
                      widget.skill.accentColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: widget.skill.accentColor.withValues(alpha: 0.12),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? widget.skill.backgroundColor
                      : AppColors.bg3,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovered
                        ? widget.skill.accentColor.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 400),
                    scale: _isHovered ? 1.15 : 1.0,
                    child: Icon(
                      widget.skill.icon,
                      color: _isHovered
                          ? widget.skill.accentColor
                          : AppColors.muted,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                style: AppTextStyles.h3.copyWith(
                  color: _isHovered ? AppColors.text : AppColors.muted2,
                ),
                child: Text(widget.skill.title),
              ),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  widget.skill.description,
                  style: AppTextStyles.body.copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: widget.skill.tags
                    .map((tag) => TechChip(
                          label: tag,
                          isHovered: _isHovered,
                          accentColor: widget.skill.accentColor,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── MOBILE — premium horizontal compact card ──
  Widget _buildMobile() {
    return _MobileSkillCard(skill: widget.skill);
  }
}

/// Premium mobile skill card — horizontal layout, compact, press feedback.
class _MobileSkillCard extends StatefulWidget {
  final SkillModel skill;
  const _MobileSkillCard({required this.skill});

  @override
  State<_MobileSkillCard> createState() => _MobileSkillCardState();
}

class _MobileSkillCardState extends State<_MobileSkillCard>
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

  @override
  Widget build(BuildContext context) {
    final skill = widget.skill;
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) => _press.forward(),
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
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: icon + title ──
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: skill.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        skill.icon,
                        color: skill.accentColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      skill.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // Accent dot
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: skill.accentColor.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Description ──
              Text(
                skill.description,
                style: AppTextStyles.body.copyWith(
                  height: 1.55,
                  fontSize: 13,
                  color: AppColors.muted,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // ── Tags ──
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: skill.tags
                    .map((tag) => _MobileChip(
                          label: tag,
                          color: skill.accentColor,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ultra-compact mobile chip — fits more tags per row.
class _MobileChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MobileChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.monoSmall.copyWith(
          color: color.withValues(alpha: 0.85),
          fontSize: 11,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
