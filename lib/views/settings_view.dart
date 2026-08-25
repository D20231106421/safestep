import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DarkPageHeader(
              title: 'Tetapan Aplikasi',
              subtitle: null,
              onBack: () => game.setGameState('menu'),
            ).animate().fadeIn(duration: 300.ms),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                children: [
                  // ── Theme Selector Section ──────────────────────────────
                  _sectionLabel(
                    'MOD TEMA TAMPILAN',
                    LucideIcons.palette,
                    AppColors.emerald,
                  ),
                  const SizedBox(height: 8),

                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildThemeOptionTile(
                          context,
                          title: 'Mod Gelap',
                          icon: LucideIcons.moon,
                          mode: ThemeMode.dark,
                          currentMode: settings.themeMode,
                          onSelect: () => settings.setThemeMode(ThemeMode.dark),
                        ),
                        Divider(
                          height: 24,
                          color: AppColors.surfaceBorderOf(context),
                        ),
                        _buildThemeOptionTile(
                          context,
                          title: 'Mod Terang',
                          icon: LucideIcons.sun,
                          mode: ThemeMode.light,
                          currentMode: settings.themeMode,
                          onSelect: () =>
                              settings.setThemeMode(ThemeMode.light),
                        ),
                        Divider(
                          height: 24,
                          color: AppColors.surfaceBorderOf(context),
                        ),
                        _buildThemeOptionTile(
                          context,
                          title: 'Ikut Sistem Peranti',
                          icon: LucideIcons.laptop,
                          mode: ThemeMode.system,
                          currentMode: settings.themeMode,
                          onSelect: () =>
                              settings.setThemeMode(ThemeMode.system),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

                  const SizedBox(height: 24),

                  // ── Notifications Settings ──────────────────────────────
                  _sectionLabel(
                    'NOTIFIKASI & AMARAN',
                    LucideIcons.bell,
                    AppColors.cyan,
                  ),
                  const SizedBox(height: 8),

                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildToggleTile(
                          context,
                          title: 'Amaran Langsung',
                          icon: LucideIcons.zap,
                          value: settings.liveAlertsEnabled,
                          onChanged: (v) => settings.setLiveAlerts(v),
                        ),
                        Divider(
                          color: AppColors.surfaceBorderOf(context),
                          height: 1,
                        ),
                        // ── Simulate Notification Button ──────────────────
                        _buildSimulateButtonTile(context, settings),
                        Divider(
                          color: AppColors.surfaceBorderOf(context),
                          height: 1,
                        ),
                        // ── Frequency Selector ────────────────────────────
                        _buildFrequencySelector(context, settings),
                      ],
                    ),
                  ).animate().fadeIn(delay: 180.ms, duration: 350.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOptionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onSelect,
  }) {
    final isSelected = currentMode == mode;
    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        // Minimum 12dp vertical padding to ensure ≥48dp touch target
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                // Solid icon background — no opacity
                color: isSelected
                    ? AppColors.emeraldBadgeBgOf(context)
                    : (isDark
                          ? AppColors.surfaceBorder
                          : AppColors.lightSurfaceBorder),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.emerald : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.emeraldBadgeTextOf(context)
                    : AppColors.textSecondaryOf(context),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimaryOf(context),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            // Custom radio indicator — larger for fat-finger friendliness
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.emerald : AppColors.textMuted,
                  width: 2.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emerald,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = AppColors.isDark(context);

    return Padding(
      // Increased padding for ≥56dp height
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
               // Solid cyan-tinted container
              color: isDark
                  ? AppColors.cyan.withValues(alpha: 0.25)
                  : const Color(0xFFCCFBF1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cyan.withValues(alpha: 0.40),
                width: 1.5,
              ),
            ),
            child: const Icon(LucideIcons.zap, color: AppColors.cyan, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimaryOf(context),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.emerald,
            inactiveTrackColor: isDark
                ? AppColors.surfaceBorder
                : AppColors.lightSurfaceBorder,
          ),
        ],
      ),
    );
  }

  /// Clickable button tile to instantly trigger a simulated push notification.
  Widget _buildSimulateButtonTile(
    BuildContext context,
    SettingsProvider settings,
  ) {
    final isDark = AppColors.isDark(context);
    final isEnabled = settings.liveAlertsEnabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled
            ? () {
                // triggerRandomAlert is async; fire-and-forget is intentional here.
                settings.triggerRandomAlert();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: isDark
                        ? AppColors.surfaceBorder
                        : AppColors.lightSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    duration: const Duration(seconds: 2),
                    content: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_rounded,
                          color: AppColors.cyan,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Notifikasi simulasi dihantar!',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimaryOf(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            : null,
        child: Padding(
          // Increased padding for ≥56dp tap target
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // Solid icon container
                  color: isEnabled
                      ? (isDark
                            ? AppColors.cyan.withValues(alpha: 0.18)
                            : const Color(0xFFCCFBF1))
                      : (isDark
                            ? AppColors.surfaceBorder
                            : AppColors.lightSurfaceBorder),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isEnabled
                        ? AppColors.cyan.withValues(alpha: 0.40)
                        : AppColors.textMuted.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  LucideIcons.bellRing,
                  color: isEnabled
                      ? AppColors.cyan
                      : AppColors.textMutedOf(context),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Simulasi Notifikasi',
                  style: GoogleFonts.plusJakartaSans(
                    color: isEnabled
                        ? AppColors.textPrimaryOf(context)
                        : AppColors.textMutedOf(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Solid pill button — prominent, no gradient opacity tricks
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isEnabled ? AppColors.cyan : AppColors.surfaceBorderOf(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.play,
                      size: 11,
                      color: isEnabled ? Colors.white : AppColors.textMutedOf(context),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'CUBA',
                      style: GoogleFonts.plusJakartaSans(
                        color: isEnabled ? Colors.white : AppColors.textMutedOf(context),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Frequency option selector for automatic periodic notifications.
  Widget _buildFrequencySelector(
    BuildContext context,
    SettingsProvider settings,
  ) {
    final isDark = AppColors.isDark(context);
    final isEnabled = settings.liveAlertsEnabled;

    final freqLabels = {'Tinggi': '15s', 'Sederhana': '45s', 'Rendah': '90s'};

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // Solid indigo-tinted container
                  color: AppColors.indigoBadgeBgOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.indigo.withValues(alpha: 0.40),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  LucideIcons.timer,
                  color: AppColors.indigoBadgeTextOf(context),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Kekerapan Notifikasi',
                  style: GoogleFonts.plusJakartaSans(
                    color: isEnabled
                        ? AppColors.textPrimaryOf(context)
                        : AppColors.textMutedOf(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Frequency segment chips — 48dp tall, clearly differentiated
          Row(
            children: SettingsProvider.frequencyOptions.map((option) {
              final isSelected = settings.alertFrequency == option;

              // Solid selected color — no opacity arithmetic
              Color? selectedBg;
              Color? selectedText;
              if (isSelected && isEnabled) {
                selectedBg = AppColors.indigoBadgeBgOf(context);
                selectedText = AppColors.indigoBadgeTextOf(context);
              }

              return Expanded(
                child: GestureDetector(
                  onTap: isEnabled
                      ? () => settings.setAlertFrequency(option)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      right: option == SettingsProvider.frequencyOptions.last
                          ? 0
                          : 6,
                    ),
                    // Min 48dp tall
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected && isEnabled
                          ? selectedBg
                          : (isDark
                                ? AppColors.surfaceBorder
                                : AppColors.lightSurfaceBorder),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected && isEnabled
                            ? AppColors.indigo
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected && isEnabled
                                ? selectedText
                                : AppColors.textMutedOf(context),
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          freqLabels[option] ?? '',
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected && isEnabled
                                ? selectedText
                                : AppColors.textMutedOf(context),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // Status indicator
          if (settings.liveAlertsEnabled) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.emerald,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .fadeOut(duration: 800.ms)
                    .then()
                    .fadeIn(duration: 800.ms),
                const SizedBox(width: 6),
                Text(
                  'Notifikasi auto setiap ${settings.notificationIntervalSeconds}s',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.emerald,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
