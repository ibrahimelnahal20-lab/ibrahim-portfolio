import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';

enum RevealType { up, left, right, fade, slowUp }

class RevealAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final RevealType type;

  const RevealAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.type = RevealType.up,
  });

  @override
  State<RevealAnimation> createState() => _RevealAnimationState();
}

class _RevealAnimationState extends State<RevealAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  Animation<Offset>? _slide; // null on mobile (opacity-only)

  // Mobile: shorter animation, NO slide transform (opacity-only).
  // Eliminates the SlideTransition compositing layer on mobile,
  // reducing GPU pressure during the startup animation cascade.
  static final bool _isMobile = PlatformUtils.isMobile;
  static const _desktopDuration = Duration(milliseconds: 600);
  static const _mobileDuration = Duration(milliseconds: 350);
  static const _curve = Curves.easeOutCubic;

  @override
  void initState() {
    super.initState();

    final duration = _isMobile
        ? _mobileDuration
        : (widget.type == RevealType.slowUp
            ? const Duration(milliseconds: 1000)
            : _desktopDuration);

    _controller = AnimationController(vsync: this, duration: duration);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: _curve),
    );

    if (!_isMobile) {
      // Desktop: full slide + fade
      Offset beginOffset;
      switch (widget.type) {
        case RevealType.up:
        case RevealType.slowUp:
          beginOffset = const Offset(0, 0.06);
          break;
        case RevealType.left:
          beginOffset = const Offset(0.06, 0);
          break;
        case RevealType.right:
          beginOffset = const Offset(-0.06, 0);
          break;
        case RevealType.fade:
          beginOffset = Offset.zero;
          break;
      }
      _slide = Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: _curve));
    }
    // Mobile: _slide stays null — opacity-only reveal

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slide;

    // Mobile: opacity-only — no compositing layer from SlideTransition
    if (slide == null) {
      return FadeTransition(
        opacity: _opacity,
        child: widget.child,
      );
    }

    // Desktop: full slide + fade
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: slide,
        child: widget.child,
      ),
    );
  }
}
