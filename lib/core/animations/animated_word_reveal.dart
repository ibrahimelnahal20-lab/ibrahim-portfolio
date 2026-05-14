import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';

class AnimatedWordReveal extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Duration delay;
  final Duration staggerDelay;

  const AnimatedWordReveal({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.delay = Duration.zero,
    this.staggerDelay = const Duration(milliseconds: 60),
  });

  @override
  State<AnimatedWordReveal> createState() => _AnimatedWordRevealState();
}

class _AnimatedWordRevealState extends State<AnimatedWordReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _words;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');

    if (PlatformUtils.isMobile) {
      // ── Mobile: shorter duration, simpler animation ──
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      // ── Desktop: full stagger ──
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800 + (_words.length * widget.staggerDelay.inMilliseconds)),
      );
    }

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
    // ── Mobile: simplified fade+translate, no scale transform ──
    if (PlatformUtils.isMobile) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)),
          child: Text(
            widget.text,
            style: widget.style,
            textAlign: widget.textAlign,
          ),
        ),
      );
    }

    // ── Desktop: per-word stagger with scale + translate + opacity ──
    return Wrap(
      alignment: _getWrapAlignment(widget.textAlign),
      children: List.generate(_words.length, (index) {
        final double start = (index * widget.staggerDelay.inMilliseconds) / _controller.duration!.inMilliseconds;
        final double end = (start + (800 / _controller.duration!.inMilliseconds)).clamp(0.0, 1.0);

        final CurvedAnimation wordAnimation = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutQuart),
        );

        return AnimatedBuilder(
          animation: wordAnimation,
          builder: (context, child) {
            final double value = wordAnimation.value;
            final double inverse = 1.0 - value;
            return Transform.translate(
              offset: Offset(0, 15 * inverse),
              child: Transform.scale(
                scale: 1.0 + (0.04 * inverse),
                child: Opacity(
                  opacity: math.pow(value, 3).toDouble().clamp(0.0, 1.0),
                  child: child,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0), // rough space width
            child: Text(
              _words[index],
              style: widget.style,
            ),
          ),
        );
      }),
    );
  }

  WrapAlignment _getWrapAlignment(TextAlign? align) {
    switch (align) {
      case TextAlign.center:
        return WrapAlignment.center;
      case TextAlign.right:
        return WrapAlignment.end;
      default:
        return WrapAlignment.start;
    }
  }
}
