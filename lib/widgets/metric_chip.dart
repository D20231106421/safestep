import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

/// A rounded pill badge / metric chip for the design system.
///
/// Uses fully solid, opaque background colors (no transparency) for maximum
/// contrast in both Dark and Light modes.
///
/// Predefined variants:
/// - [MetricChip.emerald]  — green success badge
/// - [MetricChip.indigo]   — indigo info badge
/// - [MetricChip.amber]    — amber warning badge
/// - [MetricChip.rose]     — rose danger badge
/// - [MetricChip.muted]    — neutral slate badge
class MetricChip extends StatelessWidget {
  const MetricChip({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  });

  // ── Named constructors ────────────────────────────────────────────────────
  const MetricChip.emerald({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = AppColors.emeraldBadgeBgDark,
        textColor       = AppColors.emeraldBadgeTextDark,
        borderColor     = null;

  const MetricChip.indigo({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = AppColors.indigoBadgeBgDark,
        textColor       = AppColors.indigoBadgeTextDark,
        borderColor     = null;

  const MetricChip.amber({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = AppColors.amberBadgeBgDark,
        textColor       = AppColors.amberBadgeTextDark,
        borderColor     = null;

  const MetricChip.rose({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = AppColors.roseBadgeBgDark,
        textColor       = AppColors.roseBadgeTextDark,
        borderColor     = null;

  const MetricChip.muted({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = AppColors.mutedBadgeBgDark,
        textColor       = AppColors.mutedBadgeTextDark,
        borderColor     = null;

  // ── Fields ────────────────────────────────────────────────────────────────
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? AppColors.mutedBadgeTextOf(context);
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.mutedBadgeBgOf(context),
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: fg, size: iconSize),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
