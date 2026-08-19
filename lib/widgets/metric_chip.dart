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
enum _MetricChipType {
  custom,
  emerald,
  indigo,
  amber,
  rose,
  muted,
}

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
  }) : _type = _MetricChipType.custom;

  // ── Named constructors ────────────────────────────────────────────────────
  const MetricChip.emerald({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = null,
        textColor       = null,
        borderColor     = null,
        _type           = _MetricChipType.emerald;

  const MetricChip.indigo({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = null,
        textColor       = null,
        borderColor     = null,
        _type           = _MetricChipType.indigo;

  const MetricChip.amber({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = null,
        textColor       = null,
        borderColor     = null,
        _type           = _MetricChipType.amber;

  const MetricChip.rose({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = null,
        textColor       = null,
        borderColor     = null,
        _type           = _MetricChipType.rose;

  const MetricChip.muted({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 9.0,
    this.iconSize = 11,
    this.padding,
  })  : backgroundColor = null,
        textColor       = null,
        borderColor     = null,
        _type           = _MetricChipType.muted;

  // ── Fields ────────────────────────────────────────────────────────────────
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final _MetricChipType _type;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;

    switch (_type) {
      case _MetricChipType.emerald:
        bg = AppColors.emeraldBadgeBgOf(context);
        fg = AppColors.emeraldBadgeTextOf(context);
        break;
      case _MetricChipType.indigo:
        bg = AppColors.indigoBadgeBgOf(context);
        fg = AppColors.indigoBadgeTextOf(context);
        break;
      case _MetricChipType.amber:
        bg = AppColors.amberBadgeBgOf(context);
        fg = AppColors.amberBadgeTextOf(context);
        break;
      case _MetricChipType.rose:
        bg = AppColors.roseBadgeBgOf(context);
        fg = AppColors.roseBadgeTextOf(context);
        break;
      case _MetricChipType.muted:
        bg = AppColors.mutedBadgeBgOf(context);
        fg = AppColors.mutedBadgeTextOf(context);
        break;
      case _MetricChipType.custom:
        bg = backgroundColor ?? AppColors.mutedBadgeBgOf(context);
        fg = textColor ?? AppColors.mutedBadgeTextOf(context);
        break;
    }

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
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
