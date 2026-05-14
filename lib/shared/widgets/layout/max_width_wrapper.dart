import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class MaxWidthWrapper extends StatelessWidget {
  final Widget child;
  
  const MaxWidthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSpacing.maxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
