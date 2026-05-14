// app_effects.dart
// Handles visual effects, animation durations, and curves.

import 'package:flutter/material.dart';

class AppEffects {
  AppEffects._();

  // Animation Rules
  static const Duration hoverDuration = Duration(milliseconds: 200);
  static const Duration revealDuration = Duration(milliseconds: 600);

  // Curves (No bounce/elastic, use easeOut)
  static const Curve easeOut = Curves.easeOutCubic;

  // Hover Transforms
  static final Matrix4 skillCardHoverTransform = Matrix4.translationValues(0.0, -4.0, 0.0);
  static final Matrix4 projectCardHoverTransform = Matrix4.translationValues(4.0, 0.0, 0.0);
}
