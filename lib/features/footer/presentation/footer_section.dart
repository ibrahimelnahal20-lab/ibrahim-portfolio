import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/platform_utils.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: isMobile ? AppSpacing.lg : AppSpacing.xxl,
      ),
      child: Column(
        children: [
          // ── Gradient divider ──
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.6),
                  AppColors.border.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          if (isMobile)
            _buildMobileFooter()
          else
            _buildDesktopFooter(),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: wordmark
        Text(
          'ibrahim.dev',
          style: AppTextStyles.mono.copyWith(
            color: AppColors.muted,
            fontSize: 14,
          ),
        ),
        const Spacer(),

        // Center: metadata
        Wrap(
          spacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('© ${DateTime.now().year}',
                style: AppTextStyles.footer
                    .copyWith(color: AppColors.muted2)),
            Text('·',
                style: AppTextStyles.footer
                    .copyWith(color: AppColors.muted2)),
            Text('FLUTTER + WASM',
                style: AppTextStyles.footer.copyWith(
                  color: AppColors.muted2,
                  letterSpacing: 1.5,
                )),
            Text('·',
                style: AppTextStyles.footer
                    .copyWith(color: AppColors.muted2)),
            Text('Designed & built by Ibrahim Elnahal',
                style: AppTextStyles.footer
                    .copyWith(color: AppColors.muted2)),
          ],
        ),

        const Spacer(),

        // Right: GitHub link
        _FooterGitHubLink(),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      children: [
        // Wordmark
        Text(
          'ibrahim.dev',
          style: AppTextStyles.mono.copyWith(
            color: AppColors.muted,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // GitHub link
        _FooterGitHubLink(),

        const SizedBox(height: AppSpacing.md),

        // Metadata strip
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: 4,
          children: [
            Text('© ${DateTime.now().year}',
                style: AppTextStyles.footer
                    .copyWith(color: AppColors.muted2)),
            Text('·',
                style: AppTextStyles.footer
                    .copyWith(color: AppColors.muted2)),
            Text('Flutter + WebAssembly',
                style: AppTextStyles.footer
                    .copyWith(color: AppColors.muted2)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Designed & built by Ibrahim Elnahal',
          style: AppTextStyles.footer.copyWith(color: AppColors.muted2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FooterGitHubLink extends StatefulWidget {
  @override
  State<_FooterGitHubLink> createState() => _FooterGitHubLinkState();
}

class _FooterGitHubLinkState extends State<_FooterGitHubLink> {
  bool _hovered = false;
  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _isDesktop ? (_) => setState(() => _hovered = true) : null,
      onExit: _isDesktop ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: () async {
          final uri =
              Uri.parse('https://github.com/ibrahimelnahal20-lab');
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.chips),
            border: Border.all(
              color: _hovered ? AppColors.border : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code_rounded,
                size: 14,
                color: _hovered ? AppColors.accent : AppColors.muted2,
              ),
              const SizedBox(width: 6),
              Text(
                'ibrahimelnahal20-lab',
                style: AppTextStyles.footer.copyWith(
                  color: _hovered ? AppColors.accent : AppColors.muted2,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
