import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

/// Primary gradient action button (emerald → teal) with a standard shadow.
/// Works in both Light Mode and Dark Mode.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.width,
    this.padding,
    this.borderRadius,
    this.fontSize = 13,
    this.gradientColors,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double fontSize;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors ?? [AppColors.emerald, AppColors.emeraldDeep],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: (gradientColors?.first ?? AppColors.emeraldDeep).withValues(alpha: 0.40),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Padding(
              // Minimum vertical padding to ensure ≥48dp touch target height
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary solid button — replaces translucent glass button.
/// Uses fully opaque fills to prevent visual noise from background bleed.
class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.width,
    this.padding,
    this.borderRadius,
    this.textColor,
    this.fontSize = 13,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    final isDark = AppColors.isDark(context);
    final fgColor = textColor ?? AppColors.textSecondaryOf(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      decoration: BoxDecoration(
        // Solid fill — no opacity/translucency
        color: isDark ? AppColors.surfaceBorder : Colors.white,
        borderRadius: radius,
        border: Border.all(
          color: isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          splashColor: AppColors.emerald.withValues(alpha: 0.08),
          child: Padding(
            // Minimum vertical padding to ensure ≥48dp touch target height
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: fgColor, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: fgColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
