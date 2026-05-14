import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';

class AnimatedMaskReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedMaskReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedMaskReveal> createState() => _AnimatedMaskRevealState();
}

class _AnimatedMaskRevealState extends State<AnimatedMaskReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Slightly faster on mobile for snappier perceived performance
      duration: PlatformUtils.isMobile
          ? Duration(milliseconds: (widget.duration.inMilliseconds * 0.7).round())
          : widget.duration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Mobile: simple fade + slide, no ShaderMask/ClipRect ──
    if (PlatformUtils.isMobile) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double value = _controller.value;
          return Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: FractionalTranslation(
              translation: _slideAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      );
    }

    // ── Desktop: full cinematic ShaderMask + ClipRect + cubic opacity ──
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0, -0.5),
          colors: [Colors.transparent, Colors.white],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double value = _controller.value;
            // Delay contrast sharpening with pow
            return Opacity(
              opacity: (value * value * value).clamp(0.0, 1.0),
              child: FractionalTranslation(
                translation: _slideAnimation.value,
                child: child,
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
