import 'package:flutter/material.dart';
import '../app_theme.dart';

/// A high-contrast solid card container.
///
/// Replaces the old frosted-glass (BackdropFilter) design with a fully opaque
/// solid fill for improved text contrast and accessibility.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.border,
    this.shadows,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final BoxBorder? border;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);
    final isDark = AppColors.isDark(context);

    // Solid card fill — no transparency
    final cardColor = color ??
        (isDark ? AppColors.cardFill : AppColors.lightCardFill);

    // Solid visible border
    final cardBorder = border ??
        Border.all(
          color: isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder,
          width: 1,
        );

    final cardShadows = shadows ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: radius,
        border: cardBorder,
        boxShadow: cardShadows,
      ),
      child: child,
    );
  }
}
