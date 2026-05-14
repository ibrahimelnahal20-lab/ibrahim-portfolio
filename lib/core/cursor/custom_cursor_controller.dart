import 'package:flutter/material.dart';

enum CursorHoverMode {
  none,
  text,
  button,
  card,
  accent,
}

class CustomCursorController extends ChangeNotifier {
  bool _isHovering = false;
  CursorHoverMode _hoverMode = CursorHoverMode.none;
  Offset? _magneticTarget;

  bool get isHovering => _isHovering;
  CursorHoverMode get hoverMode => _hoverMode;
  Offset? get magneticTarget => _magneticTarget;

  void setHovering(bool hovering, {CursorHoverMode mode = CursorHoverMode.none, Offset? center}) {
    if (_isHovering != hovering || _magneticTarget != center || _hoverMode != mode) {
      _isHovering = hovering;
      _hoverMode = hovering ? mode : CursorHoverMode.none;
      _magneticTarget = hovering ? center : null;
      notifyListeners();
    }
  }
}

class CustomCursorProvider extends InheritedWidget {
  final CustomCursorController controller;

  const CustomCursorProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static CustomCursorController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomCursorProvider>()?.controller;
  }

  @override
  bool updateShouldNotify(CustomCursorProvider oldWidget) => false;
}
