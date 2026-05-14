/// platform_utils.dart
/// Centralized platform detection to avoid repeated checks.
/// Used across the app to gate desktop-only or mobile-specific behavior.
library;

import 'package:flutter/foundation.dart';

class PlatformUtils {
  PlatformUtils._();

  /// Whether the current platform has a physical mouse pointer (desktop).
  /// On web, checks defaultTargetPlatform to distinguish mobile browsers.
  static final bool isDesktop = _computeIsDesktop();
  
  /// Whether the current platform is a mobile/touch device.
  static bool get isMobile => !isDesktop;

  static bool _computeIsDesktop() {
    if (kIsWeb) {
      return defaultTargetPlatform == TargetPlatform.macOS ||
             defaultTargetPlatform == TargetPlatform.windows ||
             defaultTargetPlatform == TargetPlatform.linux;
    }
    return defaultTargetPlatform == TargetPlatform.macOS ||
           defaultTargetPlatform == TargetPlatform.windows ||
           defaultTargetPlatform == TargetPlatform.linux;
  }
}
