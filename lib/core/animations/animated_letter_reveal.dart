import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_effects.dart';
import '../utils/platform_utils.dart';

class AnimatedLetterReveal extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Duration delay;
  final Duration staggerDelay;

  const AnimatedLetterReveal({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.delay = Duration.zero,
    this.staggerDelay = const Duration(milliseconds: 20),
  });

  @override
  State<AnimatedLetterReveal> createState() => _AnimatedLetterRevealState();
}

class _AnimatedLetterRevealState extends State<AnimatedLetterReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<String>? _characters;
  List<double>? _variances;

  @override
  void initState() {
    super.initState();

    if (PlatformUtils.isMobile) {
      // ── Mobile: simple whole-text fade-in, no per-character work ──
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
    } else {
      // ── Desktop: per-character stagger ──
      _characters = widget.text.split('');
      final random = math.Random(42); // fixed seed for visual consistency
      _variances = List.generate(_characters!.length, (_) => random.nextDouble() * 8.0);
      
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300 + (_characters!.length * widget.staggerDelay.inMilliseconds) + 10),
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
    // ── Mobile: single FadeTransition for the entire text ──
    if (PlatformUtils.isMobile) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: _controller, curve: AppEffects.easeOut),
        child: Text(
          widget.text,
          style: widget.style,
          textAlign: widget.textAlign,
        ),
      );
    }

    // ── Desktop: per-character stagger reveal ──
    return Wrap(
      alignment: _getWrapAlignment(widget.textAlign),
      children: List.generate(_characters!.length, (index) {
        final double baseStartMs = (index * widget.staggerDelay.inMilliseconds) + _variances![index];
        final double start = baseStartMs / _controller.duration!.inMilliseconds;
        final double end = (start + (300 / _controller.duration!.inMilliseconds)).clamp(0.0, 1.0);

        final CurvedAnimation charAnimation = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: AppEffects.easeOut),
        );

        return AnimatedBuilder(
          animation: charAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 6 * (1 - charAnimation.value)),
              child: Opacity(
                opacity: charAnimation.value,
                child: child,
              ),
            );
          },
          child: Text(
            _characters![index] == ' ' ? '\u00A0' : _characters![index], // Use non-breaking space for spaces
            style: widget.style,
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
