import 'package:flutter/material.dart';
import '../../core/utils/platform_utils.dart';

class GlowBlob extends StatefulWidget {
  final Color color;
  final double size;

  const GlowBlob({
    super.key,
    required this.color,
    this.size = 500.0,
  });

  @override
  State<GlowBlob> createState() => _GlowBlobState();
}

class _GlowBlobState extends State<GlowBlob> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _animation;

  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  void initState() {
    super.initState();
    // Only animate floating on desktop — saves 3 continuous animation controllers on mobile
    if (_isDesktop) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 8),
      )..repeat(reverse: true);

      _animation = Tween<Offset>(
        begin: const Offset(0, -4),
        end: const Offset(0, 4),
      ).animate(CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOutSine,
      ));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pre-compute effective values once per build
    final effectiveSize = _isDesktop ? widget.size : widget.size * 0.7;
    final effectiveAlpha = _isDesktop ? 0.15 : 0.10;

    final blob = Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            widget.color.withValues(alpha: effectiveAlpha),
            widget.color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );

    // ── Mobile: static blob, zero animation overhead ──
    if (!_isDesktop) {
      return blob;
    }

    // ── Desktop: animated floating (child is static, only transform rebuilds) ──
    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation!.value,
          child: child,
        );
      },
      child: blob,
    );
  }
}
