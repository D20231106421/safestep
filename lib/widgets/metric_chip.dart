import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

/// A rounded pill badge / metric chip for the dark design system.
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
    this.fontSize = 8.5,
    this.iconSize = 10,
    this.padding,
  });

  // ── Named constructors ────────────────────────────────────────────────────
  const MetricChip.emerald({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 8.5,
    this.iconSize = 10,
    this.padding,
  })  : backgroundColor = AppColors.emeraldBadgeBg,
        textColor       = AppColors.emeraldMuted,
        borderColor     = null;

  const MetricChip.indigo({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 8.5,
    this.iconSize = 10,
    this.padding,
  })  : backgroundColor = AppColors.indigoBadgeBg,
        textColor       = AppColors.indigo,
        borderColor     = null;

  const MetricChip.amber({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 8.5,
    this.iconSize = 10,
    this.padding,
  })  : backgroundColor = AppColors.amberBadgeBg,
        textColor       = AppColors.amber,
        borderColor     = null;

  const MetricChip.rose({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 8.5,
    this.iconSize = 10,
    this.padding,
  })  : backgroundColor = AppColors.roseBadgeBg,
        textColor       = AppColors.rose,
        borderColor     = null;

  const MetricChip.muted({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 8.5,
    this.iconSize = 10,
    this.padding,
  })  : backgroundColor = const Color(0x1494A3B8),
        textColor       = AppColors.textSecondary,
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
    final fg = textColor ?? AppColors.textSecondary;
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.emeraldBadgeBg,
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
            const SizedBox(width: 3),
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
