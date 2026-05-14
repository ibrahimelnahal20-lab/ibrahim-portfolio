import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/platform_utils.dart';

class GridBackground extends StatefulWidget {
  const GridBackground({super.key});

  @override
  State<GridBackground> createState() => _GridBackgroundState();
}

class _GridBackgroundState extends State<GridBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  // Static cached painters — zero re-allocation on rebuild
  // Alpha is baked in so we avoid an Opacity widget wrapper on mobile
  static final _GridPainter _mobilePainter =
      _GridPainter(spacing: 96.0, lineAlpha: 0.12);
  static final _GridPainter _desktopPainter =
      _GridPainter(spacing: 64.0, lineAlpha: 0.3);

  @override
  void initState() {
    super.initState();
    if (_isDesktop) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 8),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Mobile: static CustomPaint — no Opacity widget, no ShaderMask, zero GPU layers ──
    if (!_isDesktop) {
      return RepaintBoundary(
        child: CustomPaint(
          painter: _mobilePainter,
          child: const SizedBox.expand(),
        ),
      );
    }

    // ── Desktop: animated opacity + cinematic ShaderMask fade ──
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Opacity(
          opacity: 0.5 + (_controller!.value * 0.3),
          child: child,
        );
      },
      child: RepaintBoundary(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black,
              ],
              stops: [0.0, 0.15, 0.85, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstOut,
          child: CustomPaint(
            painter: _desktopPainter,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double spacing;
  final double lineAlpha;

  const _GridPainter({required this.spacing, required this.lineAlpha});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: lineAlpha)
      ..strokeWidth = 1.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.spacing != spacing || old.lineAlpha != lineAlpha;
}
