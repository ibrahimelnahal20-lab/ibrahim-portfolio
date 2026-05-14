// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/cursor/cursor_hover_region.dart';
import '../../../core/utils/platform_utils.dart';

class CodeCard extends StatefulWidget {
  /// When true, renders a compact version optimised for mobile viewports.
  final bool mobileCompact;

  const CodeCard({super.key, this.mobileCompact = false});

  @override
  State<CodeCard> createState() => _CodeCardState();
}

class _CodeCardState extends State<CodeCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  AnimationController? _scanlineController;
  Offset _mousePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    // Only run scanline animation on desktop — saves continuous GPU work on mobile
    if (PlatformUtils.isDesktop) {
      _scanlineController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _scanlineController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = PlatformUtils.isDesktop;
    final bool compact = widget.mobileCompact && !isDesktop;

    return CursorHoverRegion(
      mode: CursorHoverMode.card,
      child: MouseRegion(
        onEnter: isDesktop ? (_) => setState(() => _isHovered = true) : null,
        onExit: isDesktop ? (_) => setState(() => _isHovered = false) : null,
      onHover: isDesktop ? (e) {
        if (!mounted) return;
        setState(() {
          final size = context.size;
          if (size != null) {
            _mousePosition = Offset(
              (e.localPosition.dx / size.width) * 2 - 1,
              (e.localPosition.dy / size.height) * 2 - 1,
            );
          }
        });
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        // 3D perspective transform only on desktop — too expensive on mobile GPU
        transform: isDesktop && _isHovered
            ? (Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(-0.05 * _mousePosition.dy) // tilt up/down
                ..rotateY(0.05 * _mousePosition.dx) // tilt left/right
                ..translate(0.0, -10.0, 0.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.cards),
          color: AppColors.surface,
          border: Border.all(
            color: _isHovered ? AppColors.accent.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.05),
              AppColors.surface,
              AppColors.bg,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(
                alpha: _isHovered ? 0.2 : 0.05,
              ),
              blurRadius: _isHovered ? 60 : 30,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 40,
              offset: const Offset(0, 30),
            ),
          ],
        ),
        padding: const EdgeInsets.all(1.5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.cards),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accent2,
                          AppColors.syntaxKeyword,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E), // Authentic VS Code dark bg
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: const Color(0xFF252526), // VS Code Tab bar
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              _buildTrafficLight(const Color(0xFFFF5F56)),
                              const SizedBox(width: 8),
                              _buildTrafficLight(const Color(0xFFFFBD2E)),
                              const SizedBox(width: 8),
                              _buildTrafficLight(const Color(0xFF27C93F)),
                              const SizedBox(width: AppSpacing.xl),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.code,
                                      size: 14,
                                      color: AppColors.syntaxKeyword,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'engineer.dart',
                                      style: AppTextStyles.monoSmall.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.code.copyWith(
                                height: compact ? 1.5 : 1.6,
                                fontSize: compact ? 12 : 14,
                                fontFamily: 'FiraCode',
                              ),
                              children: const [
                                TextSpan(
                                  text:
                                      '// System initialized. AI workflows ready.\n',
                                  style: TextStyle(
                                    color: AppColors.syntaxComment,
                                  ),
                                ),
                                TextSpan(
                                  text: 'class ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: 'IbrahimElnahal ',
                                  style: TextStyle(
                                    color: AppColors.syntaxClass,
                                  ),
                                ),
                                TextSpan(
                                  text: 'extends ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: 'SoftwareEngineer ',
                                  style: TextStyle(
                                    color: AppColors.syntaxClass,
                                  ),
                                ),
                                TextSpan(
                                  text: '{\n',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '  final String ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: 'focus ',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '= ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: "'Frontend Systems'",
                                  style: TextStyle(
                                    color: AppColors.syntaxString,
                                  ),
                                ),
                                TextSpan(
                                  text: ';\n',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '  final List<String> ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: 'stack ',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '= ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "['Flutter', 'Dart', 'ASP.NET', 'AI Tools']",
                                  style: TextStyle(
                                    color: AppColors.syntaxString,
                                  ),
                                ),
                                TextSpan(
                                  text: ';\n\n',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '  @override\n',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: '  Future<Result> ',
                                  style: TextStyle(
                                    color: AppColors.syntaxClass,
                                  ),
                                ),
                                TextSpan(
                                  text: 'buildExperience() ',
                                  style: TextStyle(
                                    color: AppColors.syntaxFunction,
                                  ),
                                ),
                                TextSpan(
                                  text: 'async ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: '{\n',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '    await ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: 'ui.renderCinematic();\n',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '    await ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: 'architecture.enforceClean();\n',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '    return ',
                                  style: TextStyle(
                                    color: AppColors.syntaxKeyword,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Result.unforgettable;\n',
                                  style: TextStyle(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: '  }\n}',
                                  style: TextStyle(color: AppColors.text),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Animated Scanline overlay — desktop only
              if (isDesktop && _scanlineController != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _scanlineController!,
                      builder: (context, child) {
                        return FractionalTranslation(
                          translation: Offset(
                            0,
                            -1.0 + (_scanlineController!.value * 2.0),
                          ),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.accent.withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Ambient floating reflection light — desktop only
              if (isDesktop && _isHovered)
                Positioned(
                  left:
                      (MediaQuery.of(context).size.width / 2) *
                      _mousePosition.dx,
                  top: 100 * _mousePosition.dy,
                  child: IgnorePointer(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTrafficLight(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
