import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_theme.dart';

/// A frosted-glass card container.
///
/// Wraps [child] in a [ClipRRect] + [BackdropFilter] blur with
/// theme-aware translucent styling (Dark Obsidian or Light Frosted Glass).
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.border,
    this.shadows,
    this.blur = 16.0,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final BoxBorder? border;
  final List<BoxShadow>? shadows;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);
    final isDark = AppColors.isDark(context);

    final cardColor = color ??
        (isDark
            ? AppColors.cardFill.withValues(alpha: 0.7)
            : AppColors.lightCardFill);

    final cardBorder = border ??
        Border.all(
          color: isDark ? AppColors.glassBorder : AppColors.lightSurfaceBorder,
          width: 1,
        );

    final cardShadows = shadows ??
        [
          if (isDark)
            const BoxShadow(
              color: AppColors.indigoGlow,
              blurRadius: 24,
              spreadRadius: -4,
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ];

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: radius,
            border: cardBorder,
            boxShadow: cardShadows,
          ),
          child: child,
        ),
      ),
    );
  }
}
