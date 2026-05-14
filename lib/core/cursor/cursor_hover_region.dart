import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';
import 'custom_cursor_controller.dart';

export 'custom_cursor_controller.dart' show CursorHoverMode;

class CursorHoverRegion extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final CursorHoverMode mode;

  const CursorHoverRegion({
    super.key,
    required this.child,
    this.enabled = true,
    this.mode = CursorHoverMode.button,
  });

  @override
  State<CursorHoverRegion> createState() => _CursorHoverRegionState();
}

class _CursorHoverRegionState extends State<CursorHoverRegion> {
  bool _isHovering = false;

  // Use cached static field instead of computing per-build
  static final bool _isDesktopPlatform = PlatformUtils.isDesktop;

  void _updateHover(bool hovering) {
    if (_isDesktopPlatform) {
      if (_isHovering != hovering) {
        _isHovering = hovering;
        
        Offset? center;
        if (hovering) {
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            center = box.localToGlobal(box.size.center(Offset.zero));
          }
        }
        
        CustomCursorProvider.of(context)?.setHovering(hovering, mode: widget.mode, center: center);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    // If not on a desktop platform with a mouse, don't interfere
    if (!_isDesktopPlatform) {
      return widget.child;
    }
    
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => _updateHover(true),
      onExit: (_) => _updateHover(false),
      child: widget.child,
    );
  }
}
