import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'custom_cursor_controller.dart';
import '../theme/app_colors.dart';
import '../utils/platform_utils.dart';

class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> with SingleTickerProviderStateMixin {
  late CustomCursorController _controller;
  Offset _mousePos = Offset(-100, -100);
  Offset _visualDotPos = Offset(-100, -100);
  Offset _ringPos = Offset(-100, -100);
  
  late Ticker _ticker;
  bool _isVisible = false;
  
  @override
  void initState() {
    super.initState();
    _controller = CustomCursorController();
    _controller.addListener(_onHoverChanged);
    
    _ticker = createTicker(_onTick);
    if (_isDesktop) {
      _ticker.start();
    }
  }

  // Cached once — avoids per-frame computation in _onTick
  static final bool _isDesktop = PlatformUtils.isDesktop;

  @override
  void dispose() {
    _ticker.dispose();
    _controller.removeListener(_onHoverChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged() {
    if (mounted) setState(() {});
  }

  double get _outerWidth {
    if (!_controller.isHovering) return 14;
    switch (_controller.hoverMode) {
      case CursorHoverMode.text: return 4;
      case CursorHoverMode.button: return 24;
      case CursorHoverMode.card: return 32;
      case CursorHoverMode.accent: return 20;
      default: return 14;
    }
  }

  double get _outerHeight {
    if (!_controller.isHovering) return 14;
    switch (_controller.hoverMode) {
      case CursorHoverMode.text: return 24;
      case CursorHoverMode.button: return 24;
      case CursorHoverMode.card: return 32;
      case CursorHoverMode.accent: return 20;
      default: return 14;
    }
  }

  double get _outerRadius {
    if (!_controller.isHovering) return 4;
    switch (_controller.hoverMode) {
      case CursorHoverMode.text: return 2;
      case CursorHoverMode.button: return 6;
      case CursorHoverMode.card: return 8;
      case CursorHoverMode.accent: return 4;
      default: return 4;
    }
  }

  double get _innerSize {
    if (!_controller.isHovering) return 4;
    switch (_controller.hoverMode) {
      case CursorHoverMode.text: return 2;
      default: return 0; // Hide inner dot when frame expands
    }
  }

  void _onTick(Duration elapsed) {
    if (!_isDesktop) return;
    
    // Magnetic Pull Logic
    Offset targetPos = _mousePos;
    if (_controller.isHovering && _controller.magneticTarget != null) {
      final pullX = (_controller.magneticTarget!.dx - _mousePos.dx) * 0.1;
      final pullY = (_controller.magneticTarget!.dy - _mousePos.dy) * 0.1;
      targetPos = Offset(_mousePos.dx + pullX, _mousePos.dy + pullY);
    }
    
    // Immediate, sharp lerp for inner dot
    final dxInner = (targetPos.dx - _visualDotPos.dx) * 0.7;
    final dyInner = (targetPos.dy - _visualDotPos.dy) * 0.7;

    // Faster outer ring lerp for less inertia, more engineered feel
    final dxOuter = (targetPos.dx - _ringPos.dx) * 0.25;
    final dyOuter = (targetPos.dy - _ringPos.dy) * 0.25;
    
    if (dxOuter.abs() > 0.01 || dyOuter.abs() > 0.01 || dxInner.abs() > 0.01) {
      setState(() {
        _visualDotPos = Offset(_visualDotPos.dx + dxInner, _visualDotPos.dy + dyInner);
        _ringPos = Offset(_ringPos.dx + dxOuter, _ringPos.dy + dyOuter);
      });
    }
  }

  void _updatePosition(PointerEvent event) {
    if (!_isDesktop) return;
    setState(() {
      _mousePos = event.position;
      if (!_isVisible) {
        // Snap immediately on first entry to avoid fly-in effect
        _visualDotPos = _mousePos;
        _ringPos = _mousePos;
      }
      _isVisible = true;
    });
  }

  void _onPointerExit(PointerEvent event) {
    if (!_isDesktop) return;
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDesktop) return widget.child;

    return CustomCursorProvider(
      controller: _controller,
      child: MouseRegion(
        cursor: SystemMouseCursors.none,
        onExit: (e) => _onPointerExit(e),
        child: Listener(
          onPointerHover: _updatePosition,
          onPointerMove: _updatePosition,
          onPointerDown: _updatePosition,
          child: Stack(
            children: [
              widget.child,
              
              if (_isVisible)
                Positioned.fill(
                  child: IgnorePointer(
                    child: RepaintBoundary(
                      child: Stack(
                        children: [
                          // Outer Frame
                          AnimatedPositioned(
                            duration: Duration.zero,
                            left: _ringPos.dx - (_outerWidth / 2),
                            top: _ringPos.dy - (_outerHeight / 2),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutExpo,
                              width: _outerWidth,
                              height: _outerHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(_outerRadius),
                                border: Border.all(
                                  color: _controller.hoverMode == CursorHoverMode.accent 
                                      ? AppColors.accent.withValues(alpha: 0.8)
                                      : AppColors.accent.withValues(alpha: _controller.isHovering ? 0.3 : 0.15),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  if (_controller.isHovering)
                                    BoxShadow(
                                      color: AppColors.accent.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // Inner Dot
                          AnimatedPositioned(
                            duration: Duration.zero,
                            left: _visualDotPos.dx - (_innerSize / 2),
                            top: _visualDotPos.dy - (_innerSize / 2),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOutExpo,
                              width: _innerSize,
                              height: _innerSize,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(0), // Sharp edges
                                boxShadow: [
                                  if (_innerSize > 0)
                                    BoxShadow(
                                      color: AppColors.accent.withValues(alpha: 0.6),
                                      blurRadius: 4,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
