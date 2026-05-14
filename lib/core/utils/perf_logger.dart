/// perf_logger.dart
/// Lightweight debug-only performance instrumentation.
/// Zero overhead in release builds (all gated behind kDebugMode).
library;

import 'package:flutter/foundation.dart';

class PerfLogger {
  PerfLogger._();

  static final Stopwatch _sw = Stopwatch();
  static int _sectionCount = 0;
  static int _animationCount = 0;
  static int _navCount = 0;

  /// Mark application startup time (call at top of main()).
  static void markStartup() {
    if (!kDebugMode) return;
    _sw.start();
    debugPrint('[perf] ── startup marker set ──');
  }

  /// Log a named event with elapsed time from startup.
  static void log(String event) {
    if (!kDebugMode) return;
    debugPrint('[perf] $event @ ${_sw.elapsedMilliseconds}ms');
  }

  /// Log section mount (called by DeferredSection on hydration).
  static void sectionMounted(String name) {
    if (!kDebugMode) return;
    _sectionCount++;
    debugPrint(
        '[perf] section_mount: $name (#$_sectionCount) @ ${_sw.elapsedMilliseconds}ms');
  }

  /// Register an animation controller creation (optional diagnostic).
  static void animationCreated(String name) {
    if (!kDebugMode) return;
    _animationCount++;
    debugPrint(
        '[perf] animation_created: $name (total: $_animationCount) @ ${_sw.elapsedMilliseconds}ms');
  }

  /// Log a navigation request.
  static void navRequest(String target) {
    if (!kDebugMode) return;
    _navCount++;
    debugPrint(
        '[perf] nav_request: $target (count: $_navCount) @ ${_sw.elapsedMilliseconds}ms');
  }

  /// Print summary diagnostics — call after all phases complete.
  static void printDiagnostics() {
    if (!kDebugMode) return;
    debugPrint('[perf] ── diagnostics ──');
    debugPrint('[perf]   sections mounted  : $_sectionCount');
    debugPrint('[perf]   animation ctrls   : $_animationCount');
    debugPrint('[perf]   nav requests      : $_navCount');
    debugPrint('[perf]   total elapsed     : ${_sw.elapsedMilliseconds}ms');
    debugPrint('[perf] ────────────────');
  }
}
