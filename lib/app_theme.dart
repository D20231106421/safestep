import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  COLOUR TOKENS
// ─────────────────────────────────────────────
abstract class AppColors {
  // Dark Backgrounds
  static const canvas         = Color(0xFF0B0F19); // Deep Obsidian Slate
  static const surface        = Color(0xFF0F172A); // Elevated Surface
  static const cardFill       = Color(0xFF131C2E); // Card Container — fully opaque
  static const surfaceBorder  = Color(0xFF1E293B); // Subtle border

  // Light Backgrounds
  static const lightCanvas        = Color(0xFFF6FCF9);
  static const lightSurface       = Colors.white;
  static const lightCardFill      = Colors.white; // Solid white — no frost/translucency
  static const lightSurfaceBorder = Color(0xFFE6F4F0);

  // Primary Accent — Emerald / Teal
  static const emerald        = Color(0xFF10B981);
  static const emeraldDeep    = Color(0xFF0D9488);
  static const emeraldMuted   = Color(0xFF34D399);
  static const lightEmeraldMuted = Color(0xFF047857);

  // Secondary Accent — Indigo / Cyan
  static const indigo         = Color(0xFF6366F1);
  static const cyan           = Color(0xFF06B6D4);

  // Alert Accents
  static const amber          = Color(0xFFF59E0B);
  static const rose           = Color(0xFFEF4444);

  // ── Solid Badge Backgrounds — Dark Mode ──────────────────────────────────
  // High-contrast filled badges for dark surfaces
  static const emeraldBadgeBgDark  = Color(0xFF064E3B); // deep emerald-950
  static const roseBadgeBgDark     = Color(0xFF7F1D1D); // deep red-900
  static const amberBadgeBgDark    = Color(0xFF78350F); // deep amber-900
  static const indigoBadgeBgDark   = Color(0xFF312E81); // deep indigo-900
  static const mutedBadgeBgDark    = Color(0xFF1E293B); // slate-800

  // ── Solid Badge Backgrounds — Light Mode ─────────────────────────────────
  static const emeraldBadgeBgLight = Color(0xFFD1FAE5); // emerald-100
  static const roseBadgeBgLight    = Color(0xFFFEE2E2); // red-100
  static const amberBadgeBgLight   = Color(0xFFFEF3C7); // amber-100
  static const indigoBadgeBgLight  = Color(0xFFE0E7FF); // indigo-100
  static const mutedBadgeBgLight   = Color(0xFFE2E8F0); // slate-200

  // ── Solid Badge Text Colors — Dark Mode ──────────────────────────────────
  static const emeraldBadgeTextDark = Color(0xFF6EE7B7); // emerald-300
  static const roseBadgeTextDark    = Color(0xFFFCA5A5); // red-300
  static const amberBadgeTextDark   = Color(0xFFFCD34D); // amber-300
  static const indigoBadgeTextDark  = Color(0xFFA5B4FC); // indigo-300
  static const mutedBadgeTextDark   = Color(0xFFCBD5E1); // slate-300

  // ── Solid Badge Text Colors — Light Mode ─────────────────────────────────
  static const emeraldBadgeTextLight = Color(0xFF065F46); // emerald-800
  static const roseBadgeTextLight    = Color(0xFF991B1B); // red-800
  static const amberBadgeTextLight   = Color(0xFF92400E); // amber-800
  static const indigoBadgeTextLight  = Color(0xFF3730A3); // indigo-800
  static const mutedBadgeTextLight   = Color(0xFF475569); // slate-600

  // ── Legacy aliases (kept for backward compat — now point to dark solid) ──
  static const emeraldBadgeBg = emeraldBadgeBgDark;
  static const roseBadgeBg    = roseBadgeBgDark;
  static const amberBadgeBg   = amberBadgeBgDark;
  static const indigoBadgeBg  = indigoBadgeBgDark;

  // ── Amber/rose border helpers (solid) ────────────────────────────────────
  static const amberBorder    = Color(0xFF92400E); // amber-800 solid border
  static const roseBorder     = Color(0xFF991B1B); // red-800 solid border

  // Typography — Dark Mode
  static const textPrimary    = Color(0xFFF8FAFC); // Slate-50
  static const textSecondary  = Color(0xFFCBD5E1); // Slate-300 — upgraded from 400 for WCAG AA
  static const textMuted      = Color(0xFF94A3B8); // Slate-400

  // Typography — Light Mode
  static const lightTextPrimary   = Color(0xFF0F172A); // Slate-900
  static const lightTextSecondary = Color(0xFF334155); // Slate-700 — upgraded from 600 for WCAG AA
  static const lightTextMuted     = Color(0xFF64748B); // Slate-500 — upgraded from 400

  // Focus border
  static const focusBorder    = Color(0xFF10B981); // emerald solid

  // Card solid border (replaces glassBorder)
  static const glassBorder    = surfaceBorder; // solid — same as surfaceBorder

  // ── Context-aware getters ─────────────────────────────────────────────────
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color canvasOf(BuildContext context) =>
      isDark(context) ? canvas : lightCanvas;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? surface : lightSurface;

  static Color cardFillOf(BuildContext context) =>
      isDark(context) ? cardFill : lightCardFill;

  static Color surfaceBorderOf(BuildContext context) =>
      isDark(context) ? surfaceBorder : lightSurfaceBorder;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? textPrimary : lightTextPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? textSecondary : lightTextSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? textMuted : lightTextMuted;

  // ── Context-aware Badge Background getters ────────────────────────────────
  static Color emeraldBadgeBgOf(BuildContext context) =>
      isDark(context) ? emeraldBadgeBgDark : emeraldBadgeBgLight;

  static Color roseBadgeBgOf(BuildContext context) =>
      isDark(context) ? roseBadgeBgDark : roseBadgeBgLight;

  static Color amberBadgeBgOf(BuildContext context) =>
      isDark(context) ? amberBadgeBgDark : amberBadgeBgLight;

  static Color indigoBadgeBgOf(BuildContext context) =>
      isDark(context) ? indigoBadgeBgDark : indigoBadgeBgLight;

  static Color mutedBadgeBgOf(BuildContext context) =>
      isDark(context) ? mutedBadgeBgDark : mutedBadgeBgLight;

  // ── Context-aware Badge Text getters ─────────────────────────────────────
  static Color emeraldBadgeTextOf(BuildContext context) =>
      isDark(context) ? emeraldBadgeTextDark : emeraldBadgeTextLight;

  static Color roseBadgeTextOf(BuildContext context) =>
      isDark(context) ? roseBadgeTextDark : roseBadgeTextLight;

  static Color amberBadgeTextOf(BuildContext context) =>
      isDark(context) ? amberBadgeTextDark : amberBadgeTextLight;

  static Color indigoBadgeTextOf(BuildContext context) =>
      isDark(context) ? indigoBadgeTextDark : indigoBadgeTextLight;

  static Color mutedBadgeTextOf(BuildContext context) =>
      isDark(context) ? mutedBadgeTextDark : mutedBadgeTextLight;
}

// ─────────────────────────────────────────────
//  TEXT STYLE TOKENS
// ─────────────────────────────────────────────
abstract class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 32, fontWeight: FontWeight.w900,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
    fontSize: 22, fontWeight: FontWeight.w800,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
    fontSize: 13, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, height: 1.5,
  );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
    fontSize: 8.5, fontWeight: FontWeight.w800,
    color: AppColors.textMuted,
    letterSpacing: 0.8,
  );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 9, fontWeight: FontWeight.w600,
    color: AppColors.textMuted, letterSpacing: 0.3,
  );
}

// ─────────────────────────────────────────────
//  THEME DATA
// ─────────────────────────────────────────────
abstract class AppTheme {
  static ThemeData buildTheme() => buildDarkTheme();

  static ThemeData buildDarkTheme() {
    final base = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.canvas,

      colorScheme: const ColorScheme.dark(
        primary:    AppColors.emerald,
        secondary:  AppColors.indigo,
        surface:    AppColors.surface,
        error:      AppColors.rose,
        onPrimary:  Colors.white,
        onSurface:  AppColors.textPrimary,
      ),

      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 32, fontWeight: FontWeight.w900,
          color: AppColors.textPrimary, letterSpacing: -0.5,
        ),
        headlineLarge: base.headlineLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 22, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 16, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleSmall: base.titleSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 12, color: AppColors.textSecondary, height: 1.5,
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 10, color: AppColors.textSecondary, height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 8.5, fontWeight: FontWeight.w800,
          color: AppColors.textMuted, letterSpacing: 0.8,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.3,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.surfaceBorder, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.emerald;
          return AppColors.surfaceBorder;
        }),
      ),

      dividerColor: AppColors.surfaceBorder,

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.surfaceBorder),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary, fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted, fontSize: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  static ThemeData buildLightTheme() {
    final base = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightCanvas,

      colorScheme: const ColorScheme.light(
        primary:    AppColors.emerald,
        secondary:  AppColors.indigo,
        surface:    AppColors.lightSurface,
        error:      AppColors.rose,
        onPrimary:  Colors.white,
        onSurface:  AppColors.lightTextPrimary,
      ),

      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 32, fontWeight: FontWeight.w900,
          color: AppColors.lightTextPrimary, letterSpacing: -0.5,
        ),
        headlineLarge: base.headlineLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 22, fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 16, fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        titleSmall: base.titleSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 12, color: AppColors.lightTextSecondary, height: 1.5,
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 10, color: AppColors.lightTextSecondary, height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 8.5, fontWeight: FontWeight.w800,
          color: AppColors.lightTextMuted, letterSpacing: 0.8,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightCanvas,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.lightTextPrimary,
          fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.3,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextSecondary,
          side: const BorderSide(color: AppColors.lightSurfaceBorder, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.lightTextMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.emerald;
          return AppColors.lightSurfaceBorder;
        }),
      ),

      dividerColor: AppColors.lightSurfaceBorder,

      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightSurfaceBorder),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white, fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.lightTextMuted, fontSize: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightSurfaceBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
