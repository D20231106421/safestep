import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

/// Consistent page header with optional back button, title, subtitle,
/// and trailing action widgets. Adapts to Light and Dark mode.
class DarkPageHeader extends StatelessWidget {
  const DarkPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing = const [],
    this.padding,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget> trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (onBack != null) ...[
            _BackButton(onPressed: onBack!),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimaryOf(context),
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMutedOf(context),
                      letterSpacing: 0.8,
                    ),
                  ),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}

/// Circular back button with glass styling.
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceBorder.withValues(alpha: 0.6)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? AppColors.glassBorder
                : AppColors.lightSurfaceBorder,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Icon(
          Icons.chevron_left_rounded,
          color: AppColors.textSecondaryOf(context),
          size: 22,
        ),
      ),
    );
  }
}

/// Compact icon-action button for header trailing area (e.g. Reset, Add).
class HeaderActionButton extends StatelessWidget {
  const HeaderActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.label,
    this.labelColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? backgroundColor;
  final String? label;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final iconColor = color ?? AppColors.textSecondaryOf(context);
    final bgColor = backgroundColor ??
        (isDark
            ? AppColors.surfaceBorder.withValues(alpha: 0.6)
            : Colors.white);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: label != null
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 7)
            : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? AppColors.glassBorder
                : AppColors.lightSurfaceBorder,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: label != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    label!,
                    style: GoogleFonts.plusJakartaSans(
                      color: labelColor ?? iconColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              )
            : Icon(icon, color: iconColor, size: 16),
      ),
    );
  }
}
