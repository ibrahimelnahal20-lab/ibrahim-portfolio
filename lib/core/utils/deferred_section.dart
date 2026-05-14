/// deferred_section.dart
/// Phased section hydration with imperative hydrate() support.
///
/// Instead of viewport-only detection (which is unreliable in deep Column
/// children inside SliverToBoxAdapter), this uses a timer-based phased
/// approach combined with an imperative [hydrate()] API that the navbar
/// can call before scrolling to a section.
library;

import 'package:flutter/material.dart';
import 'perf_logger.dart';

/// Controller for a single deferred section.
/// Allows imperative hydration from outside (e.g., navbar navigation).
class DeferredSectionController extends ChangeNotifier {
  bool _isHydrated = false;

  bool get isHydrated => _isHydrated;

  /// Force-hydrate this section (idempotent).
  void hydrate() {
    if (!_isHydrated) {
      _isHydrated = true;
      notifyListeners();
    }
  }
}

class DeferredSection extends StatefulWidget {
  /// The section widget to defer.
  final Widget child;

  /// A debug name for performance logging.
  final String name;

  /// Placeholder height before hydration (prevents layout jump).
  final double estimatedHeight;

  /// Controller for imperative hydration.
  final DeferredSectionController controller;

  const DeferredSection({
    super.key,
    required this.child,
    required this.name,
    required this.controller,
    this.estimatedHeight = 600,
  });

  @override
  State<DeferredSection> createState() => _DeferredSectionState();
}

class _DeferredSectionState extends State<DeferredSection> {
  @override
  void initState() {
    super.initState();
    // If already hydrated (e.g., prewarm fired before widget mounted), skip
    if (widget.controller.isHydrated) return;
    // Listen for imperative hydration
    widget.controller.addListener(_onHydrated);
  }

  void _onHydrated() {
    if (!mounted) return;
    PerfLogger.sectionMounted(widget.name);
    widget.controller.removeListener(_onHydrated);
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onHydrated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isHydrated) {
      return widget.child;
    }

    // Lightweight placeholder — maintains scroll height
    return SizedBox(height: widget.estimatedHeight);
  }
}
