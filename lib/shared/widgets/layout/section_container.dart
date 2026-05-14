import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import 'max_width_wrapper.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;

  const SectionContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 850;

    return Padding(
      // Tighter vertical rhythm on mobile — avoids "vertically exhausting" feel
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 52 : AppSpacing.section,
      ),
      child: MaxWidthWrapper(
        child: child,
      ),
    );
  }
}
